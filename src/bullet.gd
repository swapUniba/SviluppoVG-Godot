class_name Bullet extends CharacterBody2D

const SPEED = 300

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play(&"idle")

func set_velocity_from_direction(direction: Vector2):
	velocity = direction * Vector2(SPEED, 0)

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.get_collider().has_method("hit"):
			collision.get_collider().hit()
		queue_free()
