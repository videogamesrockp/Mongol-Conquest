extends Node


const villain_scene = preload("res://scenes/components/villain.tscn")
var player
var tilemaplayer
var army = []

func _ready() -> void:
	tilemaplayer = get_node(get_meta("tilemap_layer"))
	player = get_node(get_meta("player"))
	spawnArmy(1, 2)


func spawnArmy(rows, columns) -> void:
	for i in range(rows):
		for j in range(columns):
			var villain = villain_scene.instantiate()
			villain.position = Vector2(32 * j + 832, 32 * i);
			army.append(villain)
			add_child(villain)
