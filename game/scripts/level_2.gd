extends Node2D

var army
# Called when the node enters the scene tree for the first time.
signal level_completed(level)
func _ready() -> void:
	army = get_node(self.get_meta("army"))
	army.all_cleared.connect(_completed)
	pass # Replace with function body.

func _completed() -> void:
	emit_signal("level_completed", 2)
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
