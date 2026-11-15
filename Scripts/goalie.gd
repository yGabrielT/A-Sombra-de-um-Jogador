class_name Goalie
extends Enemy

@export var speed := 60

var can_melee := true
var melee_timer : float
var can_jump := true
@onready var screen_notifier := $ScreenNotifier


func _ready() -> void:
	super._ready()

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
			Global.game_controller.player.health -= 10
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
			jump_to_attack()
	else:
		velocity.x = 0
	
func handle_melee_cooldown(delta):
	if !can_melee:
		if melee_timer < attack_cooldown:
			melee_timer += delta
		else:
			can_melee = true
			melee_timer = 0
		

func jump_to_attack():
	velocity.x = -speed * 2 if current_direction == Direction.LEFT else speed * 2
	if can_jump:
		velocity.y = -75
	sprite.play("melee_attack")
