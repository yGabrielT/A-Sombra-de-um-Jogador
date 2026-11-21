class_name Boss
extends Enemy

@export var speed := 60

var can_melee := true
var melee_timer : float
var can_jump = true
var grounds_nodes : Array[Node2D]
var is_on_smash_animation = false

@onready var grounds := $Grounds
@onready var screen_notifier := $ScreenNotifier
@onready var smash_sound := preload("res://Audios/The stone is crushed.mp3")

func _ready() -> void:
	super._ready()
	var area2ds = find_children("","Area2D")
	for area in area2ds:
		area.body_entered.connect(_on_ground_hit)
	print(grounds_nodes)

func _process(delta: float) -> void:
	if can_melee:
		super._process(delta)


func _physics_process(delta: float) -> void:
	velocity.y += 2.5
	if is_on_floor():
		can_jump = true
	else:
		can_jump = false
	handle_movement()
	if raycast.get_collider() != null && raycast.get_collider().name == "Player":
		if can_melee:
			can_melee = false
			print("atacou na mão")
	handle_melee_cooldown(delta)
	if health <= 0:
		queue_free()
	move_and_slide()
	


func handle_movement():
	if screen_notifier.is_on_screen():
		if can_melee:
			sprite.play("walk_cycle")
			velocity.x = -speed if current_direction == Direction.LEFT else speed
		else:
			smash()
	else:
		velocity.x = 0
	
func handle_melee_cooldown(delta):
	if !can_melee:
		if melee_timer < attack_cooldown:
			melee_timer += delta
		else:
			can_melee = true
			melee_timer = 0
		

func smash():
	velocity.x = 0
	sprite.play("smash")
	await get_tree().create_timer(.8).timeout
	if !is_on_smash_animation:
		is_on_smash_animation = true
		start_smash_anim()

func start_smash_anim():
	Global.audio_controller.play_sound_with_pitch(smash_sound,.2,.5)
	var grounds_nodes = grounds.get_children()
	var tween = get_tree().create_tween()
	tween.tween_property(grounds_nodes[0], "position", Vector2(0,-16),.1)
	tween.tween_property(grounds_nodes[0], "position", Vector2(0,40),.1)
	tween.tween_property(grounds_nodes[1], "position", Vector2(0,-16),.1)
	tween.tween_property(grounds_nodes[1], "position", Vector2(0,40),.1)
	tween.tween_property(grounds_nodes[2], "position", Vector2(0,-16),.1)
	tween.tween_property(grounds_nodes[2], "position", Vector2(0,40),.1)
	tween.tween_property(grounds_nodes[3], "position", Vector2(0,-16),.1)
	tween.tween_property(grounds_nodes[3], "position", Vector2(0,40),.1)
	tween.tween_property(grounds_nodes[4], "position", Vector2(0,-16),.1)
	tween.tween_property(grounds_nodes[4], "position", Vector2(0,40),.1)
	tween.tween_property(grounds_nodes[5], "position", Vector2(0,-16),.1)
	tween.tween_property(grounds_nodes[5], "position", Vector2(0,40),.1)
	tween.tween_callback(func (): is_on_smash_animation = false)

func _on_ground_hit(body: Node2D) -> void:
	if body.name == "Player":
		body.damage(5)
