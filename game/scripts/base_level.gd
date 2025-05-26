extends Node2D

# Override this in child levels if needed
func _level_completed() -> void:
	GameState.complete_current_level()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn") 
