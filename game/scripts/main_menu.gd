extends Control

const save_location = "user://level.json"

var contents_to_save: Dictionary = {
	"level": 1
}

func _save():
	var file = FileAccess.open(save_location, FileAccess.WRITE)
	file.store_var(contents_to_save.duplicate())
	file.close()
	
func _load():
	if FileAccess.file_exists(save_location):
		var file = FileAccess.open(save_location, FileAccess.READ)
		var data = file.get_var()
		file.close()
		
		var save_data = data.duplicate()
		
		contents_to_save.level = save_data.level
	else:
		_save()

func _ready() -> void:
	_load()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_continue_button_pressed() -> void:
	_load()
	if contents_to_save.level == 1:
		get_tree().change_scene_to_file("res://scenes/level_1.tscn")
	elif contents_to_save.level == 2:
		get_tree().change_scene_to_file("res://scenes/level_2.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/level_3.tscn")

func _on_new_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")
	contents_to_save.level = 1
	_save()

func _on_options_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/options.tscn")
