class_name PlayerController
extends CharacterBody3D

@export var walk_speed: float = 5.0
@export var sprint_speed: float = 8.5
@export var jump_velocity: float = 5.2
@export var mouse_sensitivity: float = 0.0028

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var raycast: RayCast3D = $Head/InteractionRayCast

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity", 9.8)
var is_active: bool = true
var hovered_table: ExperimentTable = null
var hud: HUD = null

# Mouse control state
var is_mouse_captured: bool = false
var is_dragging_look: bool = false

func _ready() -> void:
	# Start with mouse FREE and visible by default so users with accessibility needs never get stuck
	set_mouse_capture(false)

func set_hud(p_hud: HUD) -> void:
	hud = p_hud
	if hud:
		hud.inspector_opened.connect(_on_inspector_opened)
		hud.inspector_closed.connect(_on_inspector_closed)
		hud.mouse_toggle_requested.connect(toggle_mouse_capture)

func set_mouse_capture(captured: bool) -> void:
	is_mouse_captured = captured
	if is_mouse_captured:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if hud:
		hud.update_mouse_capture_state(is_mouse_captured)

func toggle_mouse_capture() -> void:
	if hud and hud.is_inspecting:
		return
	set_mouse_capture(not is_mouse_captured)

func _unhandled_input(event: InputEvent) -> void:
	# TAB or ESC toggles mouse capture
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_TAB:
			toggle_mouse_capture()
			get_viewport().set_input_as_handled()
			return
		elif event.keycode == KEY_ESCAPE and is_mouse_captured:
			set_mouse_capture(false)
			get_viewport().set_input_as_handled()
			return
	
	# If in inspection mode, don't handle movement / camera
	if not is_active:
		return
	
	# Right mouse button drag to look when cursor is free
	if not is_mouse_captured:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_RIGHT or event.button_index == MOUSE_BUTTON_MIDDLE:
				is_dragging_look = event.pressed
				get_viewport().set_input_as_handled()
				return
			# Click on viewport with Left Button locks mouse into camera mode
			elif event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				# If we are aiming at a table, interact!
				if hovered_table != null:
					_trigger_table_interaction(hovered_table)
					get_viewport().set_input_as_handled()
					return
				else:
					# Left click on empty space captures mouse for easy look
					set_mouse_capture(true)
					get_viewport().set_input_as_handled()
					return
		
		# Dragging with RMB rotates view
		if is_dragging_look and event is InputEventMouseMotion:
			_rotate_view(event.relative)
			get_viewport().set_input_as_handled()
			return
	else:
		# Mouse is captured: free-look directly
		if event is InputEventMouseMotion:
			_rotate_view(event.relative)
			get_viewport().set_input_as_handled()
			return
		
		# Left click while looking at a table
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if hovered_table != null:
				_trigger_table_interaction(hovered_table)
				get_viewport().set_input_as_handled()
				return
	
	# E key interact
	if event is InputEventKey and event.pressed and event.keycode == KEY_E:
		if hovered_table != null:
			_trigger_table_interaction(hovered_table)
			get_viewport().set_input_as_handled()
			return

func _rotate_view(relative: Vector2) -> void:
	rotate_y(-relative.x * mouse_sensitivity)
	head.rotate_x(-relative.y * mouse_sensitivity)
	head.rotation.x = clamp(head.rotation.x, deg_to_rad(-85.0), deg_to_rad(85.0))

func _trigger_table_interaction(table: ExperimentTable) -> void:
	table.interact()
	if hud:
		hud.open_inspector(table)

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# If in menu/inspector, stop movement
	if not is_active:
		velocity.x = move_toward(velocity.x, 0.0, walk_speed * 10.0 * delta)
		velocity.z = move_toward(velocity.z, 0.0, walk_speed * 10.0 * delta)
		move_and_slide()
		return
	
	# Jump
	var wants_jump: bool = Input.is_key_pressed(KEY_SPACE) or Input.is_action_just_pressed("ui_accept")
	if wants_jump and is_on_floor():
		velocity.y = jump_velocity
	
	# Movement Vector (WASD / Arrows)
	var move_vec := Vector2.ZERO
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		move_vec.y -= 1.0
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		move_vec.y += 1.0
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		move_vec.x -= 1.0
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		move_vec.x += 1.0
	move_vec = move_vec.normalized()
	
	# Sprint
	var is_sprinting: bool = Input.is_key_pressed(KEY_SHIFT)
	var speed: float = sprint_speed if is_sprinting else walk_speed
	
	# Direction along camera forward & right
	var direction := (transform.basis * Vector3(move_vec.x, 0.0, move_vec.y)).normalized()
	if direction != Vector3.ZERO:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 12.0)
		# NOTE: Fixed bug here! Use direction.z, NOT direction.y!
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 12.0)
	else:
		velocity.x = move_toward(velocity.x, 0.0, speed * 12.0 * delta)
		velocity.z = move_toward(velocity.z, 0.0, speed * 12.0 * delta)
	
	move_and_slide()

func _process(_delta: float) -> void:
	if not is_active:
		return
	
	# Detect interactable table via forward raycast
	var new_hovered: ExperimentTable = null
	if raycast and raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider:
			new_hovered = _find_table_in_hierarchy(collider)
	
	if new_hovered != hovered_table:
		hovered_table = new_hovered
		if hud:
			hud.set_hover_table(hovered_table)

func _find_table_in_hierarchy(node: Node) -> ExperimentTable:
	var curr: Node = node
	while curr:
		if curr is ExperimentTable:
			return curr
		curr = curr.get_parent()
	return null

func _on_inspector_opened(_table: ExperimentTable) -> void:
	is_active = false
	is_dragging_look = false
	set_mouse_capture(false)

func _on_inspector_closed() -> void:
	is_active = true
	# Keep mouse visible or captured smoothly
