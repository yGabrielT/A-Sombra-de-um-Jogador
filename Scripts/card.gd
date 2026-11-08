extends Area2D

var direction : int


func _process(_delta: float) -> void:
	if direction == Enemy.Direction.RIGHT:
		self.position.x += 2
	else:
		self.position.x -= 2
