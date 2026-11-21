class_name PlayerController
extends CharacterBody2D


@export var speed : int = 700
@export var gravity : int = 17
@export var jump_strength : int = 600
@export var shoot_strength : int = 10
@export var meele_hitbox_timer := .01
@export var ball_scene : PackedScene
@export var camera : Camera2D
@export var shoot_cooldown : float = .8
@export var health := 80

@onready var ball_pos := $BallPosition
@onready var meele_hitbox := $MeleeHitbox
@onready var meele_hitbox_col := $MeleeHitbox/col
@onready var char_sprite := $Icon
@onready var anim_tree := $AnimationTree
@onready var hit_sound := preload("res://Audios/hit 2.mp3")
@onready var walk_sound := preload("res://Audios/Walk on the grass.mp3")
@onready var punch_sound := preload("res://Audios/punch.mp3")
@onready var ball_sound := preload("res://Audios/Soccer ball bouncing 1.mp3")

var smooth_speed : float
var direction_to_mouse : Vector2
var mouse_pos : Vector2
var raw_speed : float
var is_on_air : bool
var inverse_pos : float
var shooting : bool
var meleeing : bool
var jumping : bool
var falling : bool
var shoot_timer : float
var can_shoot : bool = true
var game_paused : bool = false
var walk_sprites : Array[int] = [2,14]

func _ready() -> void:
	inverse_pos = -(ball_pos.position.x)

func _physics_process(delta: float) -> void:
	walk(delta)
	move_and_slide()
	
	follow_camera(delta)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("up"):
		jump()
	if Input.is_action_just_pressed("shoot") and can_shoot:
		can_shoot = false
		shoot()
	if Input.is_action_just_pressed("melee") and !meleeing:
		melee()
	mouse_pos = get_global_mouse_position()
	direction_to_mouse = self.global_position.direction_to(mouse_pos)
	handle_animations()
	if raw_speed == 0:
		if direction_to_mouse.x < 0:
			meele_hitbox.position.x = inverse_pos
			meele_hitbox.rotation = deg_to_rad(-180)
			ball_pos.position.x = inverse_pos
			ball_pos.rotation = deg_to_rad(-180)
			char_sprite.flip_h = true
		if direction_to_mouse.x > 0:
			ball_pos.position.x = absf(ball_pos.position.x)
			meele_hitbox.rotation = deg_to_rad(0)
			meele_hitbox.position.x = absf(ball_pos.position.x)
			ball_pos.rotation = deg_to_rad(0)
			char_sprite.flip_h = false
	
	handle_timers(delta)
func walk(delta: float) -> void:
	raw_speed = Input.get_axis("left","right") * speed
	smooth_speed = lerpf(smooth_speed,raw_speed, delta * 20)
	velocity.y += gravity
	velocity.x = smooth_speed

func jump() -> void:
	if is_on_floor():
		velocity.y = -jump_strength
		jumping = true
func shoot() -> void:
	shooting = true
	char_sprite.play("shoot")
	await get_tree().create_timer(.2).timeout
	Global.audio_controller.play_sound_with_pitch(ball_sound)
	var ball_instance := ball_scene.instantiate()
	get_tree().current_scene.add_child(ball_instance)
	ball_instance.name = "Ball"
	ball_instance.global_position = ball_pos.global_position
	var direction_to_mouse_ball = ball_pos.global_position.direction_to(mouse_pos)
	ball_instance.apply_impulse(direction_to_mouse_ball * shoot_strength)
	ball_instance.apply_torque_impulse(shoot_strength)
	shooting = false
	
	

func melee() -> void:
	meele_hitbox_col.disabled = false
	meleeing = true
	char_sprite.play("head_bump")
	Global.audio_controller.play_sound_with_pitch(punch_sound)
	await get_tree().create_timer(meele_hitbox_timer).timeout
	meleeing = false
	meele_hitbox_col.disabled = true

func follow_camera(delta: float) -> void:
	#var follow_camera_x := lerpf(camera.global_position.x, self.global_position.x, 100 * delta)
	#var follow_camera_y := lerpf(camera.global_position.y, self.global_position.y, 10 * delta)
	var follow_camera_x := self.global_position.x
	var follow_camera_y := self.global_position.y - 20
	var middle_of_cam_and_mouse_x := lerpf(follow_camera_x, mouse_pos.x, .1)
	var middle_of_cam_and_mouse_y := lerpf(follow_camera_y, mouse_pos.y, .01)
	camera.global_position = Vector2(middle_of_cam_and_mouse_x, middle_of_cam_and_mouse_y)

func handle_animations() -> void:
	if is_on_floor():
		if is_on_air:
			jumping = false
			is_on_air = false
	else:
		is_on_air = true
	char_sprite.flip_h = true if raw_speed < 0 else false 
	var idle = true if raw_speed == 0 else false
	anim_tree.set("parameters/conditions/idle", idle)
	anim_tree.set("parameters/conditions/walk", !idle)
	
func handle_timers(delta : float):
	#Shoot Timer
	if !can_shoot:
		if shoot_timer >= shoot_cooldown:
			shoot_timer = 0.0
			can_shoot = true
		else:
			shoot_timer += delta

func damage(damage_amount : int):
	health -= damage_amount
	Global.audio_controller.play_sound_with_pitch(hit_sound)
	if health <= 0:
		get_tree().change_scene_to_file("res://Scenes/MainScenes/game_over.tscn")

func _on_icon_frames_changed() -> void:
	if char_sprite.animation == "walk":
		if char_sprite.frame in walk_sprites:
			Global.audio_controller.play_sound_with_pitch(walk_sound,randf_range(0.7,1.1))
		
