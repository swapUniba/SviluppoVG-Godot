extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -100.0

@onready var attack_ref = null
@onready var can_attack = false

func _ready() -> void:
	$AnimationPlayer.play(&"idle")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if can_attack and attack_ref != null:
		var attack_dir = 1 if attack_ref.position.x - position.x > 0 else -1
		velocity.x = attack_dir * SPEED
		
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		
		can_attack = false
		await get_tree().create_timer(5).timeout
		can_attack = true
		
	move_and_slide()

	if is_on_floor():
		velocity = Vector2(0, 0)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_instance_of(body, Player):
		(body as Player).bounce(global_position, true)
	elif is_instance_of(body, Bullet):
		$DeathSound.play()
		set_deferred("$CollisionShape2D.disabled", true)
		modulate = Color(1, 0, 0, .5)
		body.queue_free()


func _on_attack_range_body_entered(body: Node2D) -> void:
	if body is Player:
		attack_ref = body
		can_attack = true


func _on_attack_range_body_exited(body: Node2D) -> void:
	if body is Player:
		attack_ref = null
		can_attack = false


func _on_death_sound_finished() -> void:
	queue_free()
