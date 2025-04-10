extends Path2D

func _ready() -> void:
	$AnimationPlayer.play("move")
	set_process(false)
