class_name coin extends Area2D

@onready var available: bool = true

func _on_body_entered(body: Node2D) -> void:
	if is_instance_of(body, Player) and available:
		set_deferred("$CollisionShape2D.disabled", true)
		self.visible = false
		$AudioStreamPlayer.play()
		available = false
		(body as Player).increase_score()

func _on_audio_stream_player_finished() -> void:
	queue_free()
