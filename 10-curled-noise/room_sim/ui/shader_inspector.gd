class_name ShaderInspector
extends Control

signal closed()

@onready var title_label: Label = %TitleLabel
@onready var subtitle_label: Label = %SubtitleLabel
@onready var description_label: Label = %DescriptionLabel
@onready var close_btn: Button = %CloseButton
@onready var reset_btn: Button = %ResetButton
@onready var mesh_option: OptionButton = %MeshOptionButton
@onready var rotate_check: CheckBox = %RotateCheckBox
@onready var presets_container: HFlowContainer = %PresetsContainer
@onready var controls_container: VBoxContainer = %ControlsContainer

var target_table: ExperimentTable
var is_updating_ui: bool = false

func _ready() -> void:
	close_btn.pressed.connect(_on_close_pressed)
	reset_btn.pressed.connect(_on_reset_pressed)
	mesh_option.item_selected.connect(_on_mesh_selected)
	rotate_check.toggled.connect(_on_rotate_toggled)
	visible = false

func open_for_table(table: ExperimentTable) -> void:
	target_table = table
	visible = true
	_populate_ui()

func close_inspector() -> void:
	visible = false
	target_table = null
	closed.emit()

func _on_close_pressed() -> void:
	close_inspector()

func _on_reset_pressed() -> void:
	if not target_table:
		return
	var defaults: Dictionary = target_table.station_data.get("default_params", {})
	target_table.apply_preset(defaults)
	_refresh_control_values()

func _on_mesh_selected(index: int) -> void:
	if not target_table:
		return
	target_table.set_mesh_type(index as StationData.MeshType)

func _on_rotate_toggled(pressed: bool) -> void:
	if not target_table:
		return
	target_table.auto_rotate = pressed

func _populate_ui() -> void:
	if not target_table:
		return
	
	is_updating_ui = true
	var data: Dictionary = target_table.station_data
	
	title_label.text = "STATION %s // %s" % [data.get("number", "00"), data.get("title", "EXPERIMENT").to_upper()]
	subtitle_label.text = data.get("subtitle", "").to_upper()
	description_label.text = data.get("description", "")
	
	# Mesh selector
	mesh_option.clear()
	mesh_option.add_item("● Subdivided Plane", StationData.MeshType.PLANE)
	mesh_option.add_item("● Torus (Donut)", StationData.MeshType.TORUS)
	mesh_option.add_item("● Sphere", StationData.MeshType.SPHERE)
	mesh_option.add_item("● Cylinder", StationData.MeshType.CYLINDER)
	mesh_option.add_item("● Cube", StationData.MeshType.BOX)
	mesh_option.selected = target_table.current_mesh_type
	mesh_option.add_theme_font_size_override("font_size", 18)
	
	rotate_check.button_pressed = target_table.auto_rotate
	rotate_check.add_theme_font_size_override("font_size", 18)
	
	# Build presets
	for child in presets_container.get_children():
		child.queue_free()
	
	var presets: Array = data.get("presets", [])
	for p in presets:
		var btn := Button.new()
		btn.text = "◆ " + p.get("name", "Preset")
		btn.custom_minimum_size = Vector2(160, 46)
		btn.add_theme_font_size_override("font_size", 16)
		btn.pressed.connect(func():
			if target_table:
				target_table.apply_preset(p.get("params", {}))
				_refresh_control_values()
		)
		presets_container.add_child(btn)
	
	# Build controls
	for child in controls_container.get_children():
		child.queue_free()
	
	var controls: Array = data.get("controls", [])
	for ctrl_def in controls:
		var c_type: String = ctrl_def.get("type", "slider")
		match c_type:
			"slider":
				_build_slider_control(ctrl_def)
			"bool":
				_build_bool_control(ctrl_def)
			"enum":
				_build_enum_control(ctrl_def)
			"color":
				_build_color_control(ctrl_def)
	
	is_updating_ui = false

func _get_param_value(def: Dictionary) -> float:
	var param_name: String = def.get("name", "")
	var comp: String = def.get("component", "")
	var raw = target_table.get_shader_param(param_name)
	if raw == null:
		return float(def.get("min", 0.0))
	if raw is Vector2:
		if comp == "x" or comp == "xy":
			return raw.x
		elif comp == "y":
			return raw.y
	return float(raw)

func _set_param_value(def: Dictionary, val: float) -> void:
	var param_name: String = def.get("name", "")
	var comp: String = def.get("component", "")
	if comp == "x":
		var current = target_table.get_shader_param(param_name)
		var f: Vector2 = current if current is Vector2 else Vector2(val, val)
		target_table.set_shader_param(param_name, Vector2(val, f.y))
	elif comp == "y":
		var current = target_table.get_shader_param(param_name)
		var f: Vector2 = current if current is Vector2 else Vector2(val, val)
		target_table.set_shader_param(param_name, Vector2(f.x, val))
	elif comp == "xy":
		var current = target_table.get_shader_param(param_name)
		if current is Vector2:
			target_table.set_shader_param(param_name, Vector2(val, val))
		else:
			target_table.set_shader_param(param_name, val)
	else:
		if def.get("step", 0.01) >= 1.0:
			target_table.set_shader_param(param_name, int(val))
		else:
			target_table.set_shader_param(param_name, val)

func _build_slider_control(def: Dictionary) -> void:
	var row := VBoxContainer.new()
	row.set_meta("ctrl_def", def)
	row.add_theme_constant_override("separation", 4)
	
	var header := HBoxContainer.new()
	var lbl := Label.new()
	lbl.text = def.get("label", "").to_upper()
	lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lbl.add_theme_font_size_override("font_size", 18)
	lbl.add_theme_color_override("font_color", Color(0.9, 0.94, 1.0))
	header.add_child(lbl)
	
	var val_lbl := Label.new()
	val_lbl.name = "ValueLabel"
	val_lbl.custom_minimum_size = Vector2(70, 0)
	val_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	val_lbl.add_theme_font_size_override("font_size", 20)
	val_lbl.add_theme_color_override("font_color", Color(0.2, 0.9, 1.0)) # LCARS Cyan
	header.add_child(val_lbl)
	row.add_child(header)
	
	var slider := HSlider.new()
	slider.name = "Slider"
	slider.min_value = def.get("min", 0.0)
	slider.max_value = def.get("max", 1.0)
	slider.step = def.get("step", 0.01)
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	slider.custom_minimum_size = Vector2(0, 32)
	
	var current_val: float = _get_param_value(def)
	slider.value = current_val
	val_lbl.text = ("%.2f" if slider.step < 1.0 else "%d") % current_val
	
	slider.value_changed.connect(func(v: float):
		if is_updating_ui or not target_table:
			return
		val_lbl.text = ("%.2f" if slider.step < 1.0 else "%d") % v
		_set_param_value(def, v)
	)
	
	row.add_child(slider)
	controls_container.add_child(row)

func _build_bool_control(def: Dictionary) -> void:
	var check := CheckBox.new()
	check.name = "Check_" + def.get("name", "")
	check.set_meta("ctrl_def", def)
	check.text = " " + def.get("label", "").to_upper()
	check.add_theme_font_size_override("font_size", 18)
	check.custom_minimum_size = Vector2(0, 42)
	
	var raw = target_table.get_shader_param(def["name"])
	check.button_pressed = bool(raw) if raw != null else false
	
	check.toggled.connect(func(b: bool):
		if is_updating_ui or not target_table:
			return
		target_table.set_shader_param(def["name"], b)
	)
	controls_container.add_child(check)

func _build_enum_control(def: Dictionary) -> void:
	var row := VBoxContainer.new()
	row.set_meta("ctrl_def", def)
	row.add_theme_constant_override("separation", 4)
	
	var lbl := Label.new()
	lbl.text = def.get("label", "").to_upper()
	lbl.add_theme_font_size_override("font_size", 18)
	lbl.add_theme_color_override("font_color", Color(0.9, 0.94, 1.0))
	row.add_child(lbl)
	
	var opt := OptionButton.new()
	opt.name = "EnumOption"
	opt.custom_minimum_size = Vector2(0, 46)
	opt.add_theme_font_size_override("font_size", 18)
	var options: Array = def.get("options", [])
	for i in options.size():
		opt.add_item("▸ " + options[i], i)
	
	var raw = target_table.get_shader_param(def["name"])
	var current_idx: int = int(raw) if raw != null else 0
	opt.selected = current_idx
	
	opt.item_selected.connect(func(idx: int):
		if is_updating_ui or not target_table:
			return
		target_table.set_shader_param(def["name"], idx)
	)
	
	row.add_child(opt)
	controls_container.add_child(row)

func _build_color_control(def: Dictionary) -> void:
	var row := HBoxContainer.new()
	row.set_meta("ctrl_def", def)
	row.custom_minimum_size = Vector2(0, 46)
	
	var lbl := Label.new()
	lbl.text = def.get("label", "").to_upper()
	lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lbl.add_theme_font_size_override("font_size", 18)
	lbl.add_theme_color_override("font_color", Color(0.9, 0.94, 1.0))
	row.add_child(lbl)
	
	var picker_btn := ColorPickerButton.new()
	picker_btn.name = "ColorPicker"
	picker_btn.custom_minimum_size = Vector2(100, 38)
	
	var raw = target_table.get_shader_param(def["name"])
	var col: Color = Color.WHITE
	if raw is Color:
		col = raw
	elif raw is Vector3:
		col = Color(raw.x, raw.y, raw.z)
	
	picker_btn.color = col
	picker_btn.color_changed.connect(func(c: Color):
		if is_updating_ui or not target_table:
			return
		var current = target_table.get_shader_param(def["name"])
		if current is Vector3:
			target_table.set_shader_param(def["name"], Vector3(c.r, c.g, c.b))
		else:
			target_table.set_shader_param(def["name"], c)
	)
	
	row.add_child(picker_btn)
	controls_container.add_child(row)

func _refresh_control_values() -> void:
	if not target_table:
		return
	is_updating_ui = true
	for child in controls_container.get_children():
		if not child.has_meta("ctrl_def"):
			continue
		var def: Dictionary = child.get_meta("ctrl_def")
		var c_type: String = def.get("type", "")
		var c_name: String = def.get("name", "")
		
		match c_type:
			"slider":
				var slider: HSlider = child.get_node_or_null("Slider")
				var val_lbl: Label = child.get_node_or_null("ValueLabel")
				if slider and val_lbl:
					var val: float = _get_param_value(def)
					slider.value = val
					val_lbl.text = ("%.2f" if slider.step < 1.0 else "%d") % val
			"bool":
				if child is CheckBox:
					var raw = target_table.get_shader_param(c_name)
					child.button_pressed = bool(raw) if raw != null else false
			"enum":
				var opt: OptionButton = child.get_node_or_null("EnumOption")
				if opt:
					var raw = target_table.get_shader_param(c_name)
					opt.selected = int(raw) if raw != null else 0
			"color":
				var picker_btn: ColorPickerButton = child.get_node_or_null("ColorPicker")
				if picker_btn:
					var raw = target_table.get_shader_param(c_name)
					if raw is Color:
						picker_btn.color = raw
					elif raw is Vector3:
						picker_btn.color = Color(raw.x, raw.y, raw.z)
	is_updating_ui = false
