extends Node2D

const save_location = "user://level.json"
var army

var contents_to_save: Dictionary = {
	"level": 2
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	army = get_node(self.get_meta("army"))
	army.all_dead.connect(_on_cleared)
	pass # Replace with function body.

func _on_cleared() -> void:
	var file = FileAccess.open(save_location, FileAccess.WRITE)
	file.store_var(contents_to_save.duplicate())
	file.close()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
