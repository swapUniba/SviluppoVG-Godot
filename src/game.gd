extends Node2D

@onready var heart_scene = preload("res://src/Heart.tscn")

func _ready() -> void:
	
	for i in range($Level/Character.health):
		var heart = heart_scene.instantiate()
		$CanvasLayer/UI/HealthBar.add_child(heart)
	
	$Level/Character.score_changed.connect(_on_score_increased)
	$Level/Character.health_changed.connect(_on_health_changed)
	$Level/Character.dead.connect(_on_death)

func _on_score_increased():
	$CanvasLayer/UI/ScoreBar/Label.text = str($Level/Character.score)

func _on_health_changed():
	var health_containers = $CanvasLayer/UI/HealthBar.get_children()
	health_containers.reverse()
	for x in health_containers:
		if x.modulate != Color(0, 1, 0):
			x.modulate = Color(0, 1, 0)
			x.get_child(-1).queue_free()
			break

func _on_death():
	$CanvasLayer2/DeathMenu.visible = true
	get_tree().paused = not get_tree().paused
	
