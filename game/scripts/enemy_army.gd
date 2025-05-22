extends Node


var villain_scene = preload("res://villain.tscn")


func _ready() -> void:
	spawnArmy(2, 32)


func spawnArmy(rows, columns) -> void:
	for i in range(rows):
		for j in range(columns):
			var villain = villain_scene.instantiate()
			villain.position = Vector2(32 * j, i * 32 + 384);
			add_child(villain)


func army_movement_timer() -> void:
	pass # Replace with function body.
