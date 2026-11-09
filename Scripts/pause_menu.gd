extends PanelContainer

var game_paused : bool = false


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		pausar()

func pausar():
	game_paused = !game_paused
	get_tree().paused = game_paused
	self.visible = game_paused


func _on_button_pressed() -> void:
	pausar()


func _on_button_2_pressed() -> void:
	get_tree().quit()
