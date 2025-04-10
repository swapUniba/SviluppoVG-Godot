extends CanvasLayer

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/Game.tscn")

func _on_texture_button_2_pressed() -> void:
	get_tree().quit()
