class_name PlayerController
extends CharacterBody2D


@export var speed : int = 700
@export var gravity : int = 17
@export var jump_strength : int = 600
@export var shoot_strength : int = 10
@export var meele_hitbox_timer := .1
@export var ball_scene : PackedScene
@export var camera : Camera2D

@onready var ball_pos := $BallPosition
@onready var meele_hitbox := $BallPosition/MeleeHitbox

var smooth_speed : float
var direction_to_mouse : Vector2
var mouse_pos : Vector2

func _physics_process(delta: float) -> void:
	walk(delta)
	if Input.is_action_just_pressed("up"):
		jump()
	if Input.is_action_just_pressed("shoot"):
		shoot()
	if Input.is_action_just_pressed("melee"):
		melee()
	mouse_pos = get_global_mouse_position()
	direction_to_mouse = ball_pos.global_position.direction_to(mouse_pos)
	if direction_to_mouse.x < 0:
		ball_pos.position.x = -22
		ball_pos.rotation = -180
	else:
		ball_pos.position.x = 22
		ball_pos.rotation = 0
	follow_camera(delta)
	move_and_slide()

func walk(delta: float) -> void:
	var raw_speed := Input.get_axis("left","right") * speed
	smooth_speed = lerpf(smooth_speed,raw_speed, delta * 20)
	velocity.y += gravity
	velocity.x = smooth_speed

func jump() -> void:
	if is_on_floor():
		velocity.y = -jump_strength

func shoot() -> void:
	var ball_instance := ball_scene.instantiate()
	get_tree().current_scene.add_child(ball_instance)
	ball_instance.global_position = ball_pos.global_position
	
	print(direction_to_mouse)
	ball_instance.apply_impulse(direction_to_mouse * shoot_strength)
	
	
	

func melee() -> void:
	meele_hitbox.monitoring = true
	print("Iniciou carrinho")
	await get_tree().create_timer(meele_hitbox_timer).timeout
	print("Terminou carrinho")
	meele_hitbox.monitoring = false

func follow_camera(delta: float) -> void:
	var follow_camera_x := lerpf(camera.global_position.x, self.global_position.x, 100 * delta)
	var follow_camera_y := lerpf(camera.global_position.y, self.global_position.y, 10 * delta)
	var middle_of_cam_and_mouse_x := lerpf(follow_camera_x, mouse_pos.x, .1)
	var middle_of_cam_and_mouse_y := lerpf(follow_camera_y, mouse_pos.y, .01)
#	var middle_of_cam_and_mouse := Vector2(follow_camera_x,follow_camera_y).lerp(mouse_pos, .1)
	camera.global_position = Vector2(middle_of_cam_and_mouse_x, middle_of_cam_and_mouse_y)

func _on_melee_hitbox_area_entered(area: Area2D) -> void:
	print(area)
