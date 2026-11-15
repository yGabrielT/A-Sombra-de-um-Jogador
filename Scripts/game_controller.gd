class_name GameController
extends Node2D

var player : PlayerController
var enemys_killed : int = 0

func _ready() -> void:
	Global.game_controller = self
	player = get_tree().get_first_node_in_group("Player")
	
func _process(delta: float) -> void:
	if enemys_killed >= 6:
		get_tree().change_scene_to_file("res://Scenes/MainScenes/win_screen.tscn")
