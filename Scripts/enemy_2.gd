extends Area2D

@export var shoot_cooldown := 1
@export var card_scene : PackedScene
@export var health := 100
@onready var raycast := $RayCast2D
var can_melee := true
var melee_timer : float
var can_walk := true
var direction = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Global.game_controller.player.global_position.x < self.global_position.x:
		self.scale.x = -1
		direction = -1
		if can_melee:
			self.position.x -= 2
	else:
		direction = 1
		self.scale.x = 1
		if can_melee:
			self.position.x += 2
	if raycast.get_collider() != null && raycast.get_collider().name == "Player":
		if can_melee:
			can_melee = false
			print("atacou na mão")
			Global.game_controller.player.health -= 10
	melee(delta)
	if health <= 0:
		queue_free()


func melee(delta):
	
	if !can_melee:
		if melee_timer < shoot_cooldown:
			melee_timer += delta
		else:
			can_melee = true
			melee_timer = 0
		


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Ball":
		health -= 35
		body.queue_free()
