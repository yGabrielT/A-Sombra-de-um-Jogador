class_name GameController
extends Node2D

var player : PlayerController

func _ready() -> void:
	Global.game_controller = self
	player = get_tree().get_first_node_in_group("Player")
func _process(delta: float) -> void:
	pass
