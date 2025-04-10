extends Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_text_backspace"):
		self.visible = not self.visible
		get_tree().paused = not get_tree().paused

func _on_texture_button_pressed() -> void:
	self.visible = false
	get_tree().paused = false


func _on_texture_button_2_pressed() -> void:
	self.visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://src/MainMenu.tscn")
