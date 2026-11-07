extends CharacterBody2D

@export var shoot_cooldown := 1
@export var card_scene : PackedScene
@export var health := 100
@export var speed := 60

@onready var raycast := $RayCast2D
@onready var sprite := $AnimatedSprite2D
var can_melee := true
var melee_timer : float
var can_walk := true
var direction = 1
var initial_target_pos : Vector2
var can_jump = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_target_pos = raycast.target_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	print(can_jump)
	velocity.y += 2.5
	if is_on_floor():
		can_jump = true
	else:
		can_jump = false
	if Global.game_controller.player.global_position.x > self.global_position.x:
		handle_movement(1)
	if Global.game_controller.player.global_position.x <= self.global_position.x:
		handle_movement(-1)
	if raycast.get_collider() != null && raycast.get_collider().name == "Player":
		if can_melee:
			can_melee = false
			print("atacou na mão")
			Global.game_controller.player.health -= 10
	melee(delta)
	if health <= 0:
		queue_free()
	move_and_slide()
	


func handle_movement(cur_direction : int):
	
	if can_melee:
		direction = cur_direction
		sprite.flip_h = true if cur_direction == -1 else false
		raycast.target_position = -initial_target_pos if cur_direction == -1 else initial_target_pos
		sprite.play("walk_cycle")
		velocity.x = -speed if cur_direction == -1 else speed
	else:
		jump_to_attack()
	
func melee(delta):
	if !can_melee:
		if melee_timer < shoot_cooldown:
			melee_timer += delta
		else:
			can_melee = true
			melee_timer = 0
		

func jump_to_attack():
	velocity.x = -speed * 2 if direction == -1 else speed * 2
	if can_jump:
		velocity.y = -75
	sprite.play("melee_attack")
		

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Ball":
		sprite.play("melee_attack")
		health -= 35
		body.queue_free()
