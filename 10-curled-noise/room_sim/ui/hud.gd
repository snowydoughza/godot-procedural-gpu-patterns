class_name HUD
extends CanvasLayer

signal inspector_opened(table: ExperimentTable)
signal inspector_closed()
signal mouse_toggle_requested()

@onready var reticle: CenterContainer = $ReticleContainer
@onready var reticle_dot: ColorRect = $ReticleContainer/Dot
@onready var reticle_ring: Panel = $ReticleContainer/Ring
@onready var prompt_container: CenterContainer = $PromptContainer
@onready var prompt_label: Label = $PromptContainer/PromptPanel/PromptLabel
@onready var key_hints: Label = $BottomBar/Margin/KeyHints
@onready var mouse_toggle_btn: Button = $TopBar/Margin/HBox/MouseToggleBtn
@onready var banner_label: Label = $TopBar/Margin/HBox/BannerLabel
@onready var shader_inspector: ShaderInspector = $ShaderInspector

var current_target_table: ExperimentTable = null
var is_inspecting: bool = false
var is_mouse_captured: bool = false

func _ready() -> void:
	prompt_container.visible = false
	shader_inspector.closed.connect(_on_inspector_closed)
	mouse_toggle_btn.pressed.connect(func(): mouse_toggle_requested.emit())
	_set_reticle_active(false)
	update_mouse_capture_state(false)

func update_mouse_capture_state(captured: bool) -> void:
	is_mouse_captured = captured
	if captured:
		mouse_toggle_btn.text = "🔒 MOUSE: LOCKED (PRESS TAB/ESC TO FREE)"
		mouse_toggle_btn.modulate = Color(1.0, 0.6, 0.0) # LCARS Amber
	else:
		mouse_toggle_btn.text = "🖱️ MOUSE: VISIBLE (CLICK SCREEN OR TAB TO LOCK)"
		mouse_toggle_btn.modulate = Color(0.2, 0.9, 1.0) # LCARS Cyan

func set_hover_table(table: ExperimentTable) -> void:
	if is_inspecting:
		return
	
	if current_target_table != table:
		if current_target_table:
			current_target_table.set_highlight(false)
		current_target_table = table
		if current_target_table:
			current_target_table.set_highlight(true)
	
	if table:
		var st_title: String = table.station_data.get("title", "EXPERIMENT")
		var st_num: String = table.station_data.get("number", "00")
		prompt_label.text = "▶ [E] OR LEFT-CLICK: ACCESS STATION %s — %s ◀" % [st_num, st_title.to_upper()]
		prompt_container.visible = true
		_set_reticle_active(true)
	else:
		prompt_container.visible = false
		_set_reticle_active(false)

func _set_reticle_active(active: bool) -> void:
	if active:
		reticle_dot.color = Color(1.0, 0.65, 0.0, 1.0) # LCARS Gold
		reticle_dot.custom_minimum_size = Vector2(10, 10)
		reticle_ring.visible = true
	else:
		reticle_dot.color = Color(0.3, 0.85, 1.0, 0.85) # LCARS Cyan
		reticle_dot.custom_minimum_size = Vector2(6, 6)
		reticle_ring.visible = false

func open_inspector(table: ExperimentTable) -> void:
	is_inspecting = true
	prompt_container.visible = false
	reticle.visible = false
	$BottomBar.visible = false
	shader_inspector.open_for_table(table)
	inspector_opened.emit(table)

func close_inspector() -> void:
	shader_inspector.close_inspector()

func _on_inspector_closed() -> void:
	is_inspecting = false
	reticle.visible = true
	$BottomBar.visible = true
	if current_target_table:
		set_hover_table(current_target_table)
	inspector_closed.emit()

func _unhandled_input(event: InputEvent) -> void:
	if is_inspecting:
		if event.is_action_pressed("ui_cancel") or (event is InputEventKey and event.pressed and event.keycode == KEY_E):
			close_inspector()
			get_viewport().set_input_as_handled()
