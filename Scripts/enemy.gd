class_name Enemy
extends CharacterBody2D

@export var health := 100
@export var attack_cooldown := 1

enum Direction {LEFT,RIGHT}

var current_direction : int
var initial_raycast_target_position : Vector2

@onready var raycast : RayCast2D = $RayCast2D
@onready var sprite : AnimatedSprite2D = $Sprite

func _ready() -> void:
	initial_raycast_target_position = raycast.target_position

func _process(delta: float) -> void:
	check_direction()

func check_direction():
	if Global.game_controller.player.global_position.x > self.global_position.x:
		current_direction = Direction.RIGHT
		raycast.target_position = initial_raycast_target_position
		sprite.flip_h = false
	if Global.game_controller.player.global_position.x <= self.global_position.x:
		current_direction = Direction.LEFT
		raycast.target_position = -initial_raycast_target_position
		sprite.flip_h = true

func on_enemy_hit(body: Node2D) -> void:
	
	if body.name.contains("Ball"):
		health -= 35
		if health <= 0:
			self.queue_free()
		body.queue_free()

func on_area_enemy_hit(area: Area2D) -> void:
	print(area.name)
	if area.name == "MeleeHitbox":
		health -= 10
		if health <= 0:
			self.queue_free()
