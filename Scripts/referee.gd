class_name Referee
extends Enemy

@export var card_scene : PackedScene
var can_shoot := true
var shoot_timer : float


func _ready() -> void:
	super._ready()


func _process(delta: float) -> void:
	super._process(delta)
	if raycast.get_collider() != null && raycast.get_collider().name == "Player":
		shoot_card(delta)
	if health <= 0:
		queue_free()


func shoot_card(delta):
	if can_shoot:
		can_shoot = false
		var card_instance = card_scene.instantiate()
		get_tree().current_scene.add_child(card_instance)
		card_instance.direction = current_direction
		card_instance.global_position = self.global_position
		card_instance.rotation = -180
		print("jogou carta")
	else:
		if shoot_timer < attack_cooldown:
			shoot_timer += delta
		else:
			can_shoot = true
			shoot_timer = 0
