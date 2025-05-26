extends Control

var level = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_continue_button_pressed() -> void:
	if level == 1:
		get_tree().change_scene_to_file("res://scenes/level_1.tscn")
	elif level == 2:
		get_tree().change_scene_to_file("res://scenes/level_2.tscn")
	elif level == 3:
		get_tree().change_scene_to_file("res://scenes/level_3.tscn")

func _on_new_game_button_pressed() -> void:
	level = 1
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")

func _on_options_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/options.tscn")
