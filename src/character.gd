class_name Player extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var movable: bool = false
@onready var is_damaged: bool = false
@onready var is_dead: bool = false
@onready var can_shoot: bool = true

@export var score: int = 0
@export var health: int = 3
@export var bullet_scene: PackedScene

signal hit
signal score_changed
signal health_changed
signal dead

func _animation_setter(animation_name) -> void:
	$AnimatedSprite2D.play(animation_name)

func _ready() -> void:
	_animation_setter(&"idle")

func _process(delta: float) -> void:
	
	var animation_name = &"idle"
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		animation_name = &"run"
	
	if is_dead:
		animation_name = &"death"
		
	_animation_setter(animation_name)
	
	if Input.is_action_just_pressed("ui_left"):
		$AnimatedSprite2D.flip_h = true
	elif Input.is_action_just_pressed("ui_right"):
		$AnimatedSprite2D.flip_h = false
	
	if Input.is_action_just_pressed("fire") and can_shoot:
		var bullet = bullet_scene.instantiate()
		var direction = -1 if $AnimatedSprite2D.flip_h else 1
		bullet.global_position = Vector2(global_position.x, global_position.y)
		bullet.set_velocity_from_direction(Vector2(direction, 0))
		get_tree().root.add_child(bullet)
		can_shoot = false
		$ShootTimer.start(3)
		$ShootPlayer.play()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction and movable:
		velocity.x = direction * SPEED
	else:
		if movable:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		else:
			velocity.x = move_toward(velocity.x, 0, 20)
	
	if is_on_floor() and velocity.x == 0:
		movable = true
	
	move_and_slide()
	
	# get collisions from move and slide and retrieve info from the tilemap
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if is_instance_of(collision.get_collider(), TileMapLayer):
			var tile_map = collision.get_collider() as TileMapLayer
			var tile_data = tile_map.get_cell_tile_data(tile_map.local_to_map(tile_map.to_local(collision.get_position())))
			if tile_data:
				var damage = tile_data.get_custom_data("damage")
				if damage:
					hit.emit()

func bounce(ref_position: Vector2, damage: bool):
	var direction = (global_position - ref_position).normalized()
	velocity = (direction.sign() * SPEED).reflect(direction)
	movable = false
	
	if damage:
		hit.emit()

func increase_score():
	score += 1
	score_changed.emit()

func _on_shoot_timer_timeout() -> void:
	can_shoot = true

func _on_hit() -> void:
	if not is_damaged:
		is_damaged = true
		health -= 1
		$HitPlayer.play()
		health_changed.emit()
		
		modulate = Color(1, 0, 0, .5)
		
		if health == 0:
			is_dead = true
			movable = false
		else:
			await get_tree().create_timer(5).timeout
			is_damaged = false
			modulate = Color(1, 1, 1, 1)
			modulate.a = 1
	


func _on_animated_sprite_2d_animation_finished() -> void:
	dead.emit()
