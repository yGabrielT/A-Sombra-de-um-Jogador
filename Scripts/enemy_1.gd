extends Area2D

@export var shoot_cooldown := 1
@export var card_scene : PackedScene

@onready var raycast := $RayCast2D
var can_shoot := true
var shoot_timer : float
var direction = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.game_controller.player.global_position.x < self.global_position.x:
		self.scale.x = -1
		direction = -1
	else:
		direction = 1
		self.scale.x = 1
	
	if raycast.get_collider() != null && raycast.get_collider().name == "Player":
		shoot_card(delta)


func shoot_card(delta):
	if can_shoot:
		can_shoot = false
		var card_instance = card_scene.instantiate()
		get_tree().current_scene.add_child(card_instance)
		card_instance.direction = direction
		card_instance.global_position = self.global_position
		card_instance.rotation = -180
		print("jogou carta")
	else:
		if shoot_timer < shoot_cooldown:
			shoot_timer += delta
		else:
			can_shoot = true
			shoot_timer = 0
		
