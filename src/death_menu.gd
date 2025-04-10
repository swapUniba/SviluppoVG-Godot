extends Control


func _on_texture_button_pressed() -> void:
	self.visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://src/Game.tscn")
