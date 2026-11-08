extends Area2D

var direction : int


func _process(_delta: float) -> void:
	if direction == Enemy.Direction.RIGHT:
		self.position.x += 2
	else:
		self.position.x -= 2


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.health -= 10
		queue_free()
