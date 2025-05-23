extends Node


const villain_scene = preload("res://villain.tscn")
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
			villain.player_node = player
			villain.tilemap_layer_node = tilemaplayer
			army.append(villain)
			add_child(villain)


func army_movement_timer() -> void:
	for c in army:
		if c:
			c.move()
