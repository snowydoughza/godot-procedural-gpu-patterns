class_name ExperimentTable
extends StaticBody3D

@export var station_index: int = 0
@export var auto_rotate: bool = true
@export var rotation_speed: float = 0.35

@onready var demo_pivot: Node3D = $DemoPivot
@onready var demo_mesh_instance: MeshInstance3D = $DemoPivot/DemoMesh
@onready var station_title_label: Label3D = $Plaque/TitleLabel
@onready var station_desc_label: Label3D = $Plaque/DescLabel
@onready var glow_ring: MeshInstance3D = $Pedestal/GlowRing
@onready var interaction_area: Area3D = $InteractionArea

var station_data: Dictionary
var active_material: ShaderMaterial
var current_mesh_type: StationData.MeshType = StationData.MeshType.PLANE
var is_highlighted: bool = false

signal interacted(table: ExperimentTable)

func _ready() -> void:
	var defs := StationData.get_station_definitions()
	if station_index >= 0 and station_index < defs.size():
		station_data = defs[station_index]
	else:
		station_data = defs[0]
	
	_setup_table_display()

func _setup_table_display() -> void:
	if station_title_label:
		station_title_label.text = "[ %s ]  %s" % [station_data.get("number", "00"), station_data.get("title", "Experiment")]
	if station_desc_label:
		station_desc_label.text = station_data.get("subtitle", "")
	
	# Load shader and create unique material
	var shader_path: String = station_data.get("shader_path", "")
	var shader_res = load(shader_path)
	if shader_res is Shader:
		active_material = ShaderMaterial.new()
		active_material.shader = shader_res
		
		# Apply default params
		var defaults: Dictionary = station_data.get("default_params", {})
		for key in defaults:
			active_material.set_shader_parameter(key, defaults[key])
		
		demo_mesh_instance.material_override = active_material
	
	# Set default mesh
	current_mesh_type = station_data.get("default_mesh", StationData.MeshType.PLANE)
	set_mesh_type(current_mesh_type)

func _process(delta: float) -> void:
	if auto_rotate and demo_pivot:
		demo_pivot.rotate_y(rotation_speed * delta)

func set_mesh_type(type: StationData.MeshType) -> void:
	current_mesh_type = type
	var new_mesh := StationData.get_mesh(type)
	demo_mesh_instance.mesh = new_mesh
	
	# Adjust pivot height or tilt if needed
	if type == StationData.MeshType.PLANE:
		demo_mesh_instance.rotation_degrees = Vector3(15.0, 0.0, 0.0)
		demo_mesh_instance.position = Vector3(0.0, 0.1, 0.0)
	elif type == StationData.MeshType.TORUS:
		demo_mesh_instance.rotation_degrees = Vector3(35.0, 0.0, 0.0)
		demo_mesh_instance.position = Vector3(0.0, 0.15, 0.0)
	else:
		demo_mesh_instance.rotation_degrees = Vector3.ZERO
		demo_mesh_instance.position = Vector3(0.0, 0.2, 0.0)

func set_shader_param(param_name: String, val) -> void:
	if active_material:
		active_material.set_shader_parameter(param_name, val)

func get_shader_param(param_name: String):
	if active_material:
		return active_material.get_shader_parameter(param_name)
	return null

func apply_preset(preset_params: Dictionary) -> void:
	if not active_material:
		return
	for key in preset_params:
		active_material.set_shader_parameter(key, preset_params[key])

func set_highlight(highlight: bool) -> void:
	if is_highlighted == highlight:
		return
	is_highlighted = highlight
	
	if glow_ring and glow_ring.material_override is StandardMaterial3D:
		var mat: StandardMaterial3D = glow_ring.material_override
		if highlight:
			mat.emission_energy_multiplier = 4.0
			mat.albedo_color = Color(0.2, 0.9, 1.0)
			mat.emission = Color(0.2, 0.9, 1.0)
		else:
			mat.emission_energy_multiplier = 1.2
			mat.albedo_color = Color(0.1, 0.5, 0.8)
			mat.emission = Color(0.1, 0.5, 0.8)

func interact() -> void:
	interacted.emit(self)
