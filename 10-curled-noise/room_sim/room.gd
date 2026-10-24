class_name Room
extends Node3D

@onready var player: PlayerController = $Player
@onready var hud: HUD = $HUD
@onready var tables_parent: Node3D = $Tables

func _ready() -> void:
	if player and hud:
		player.set_hud(hud)

func get_table(index: int) -> ExperimentTable:
	if tables_parent and index >= 0 and index < tables_parent.get_child_count():
		return tables_parent.get_child(index) as ExperimentTable
	return null
