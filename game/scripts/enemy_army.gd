extends Node


const villain_scene = preload("res://villain.tscn")

var army = []

func _ready() -> void:
	spawnArmy(18, 2)


func spawnArmy(rows, columns) -> void:
	for i in range(rows):
		for j in range(columns):
			var villain = villain_scene.instantiate()
			villain.position = Vector2(32 * j + 832, 32 * i);
			army.append(villain)
			add_child(villain)


func army_movement_timer() -> void:
	for c in army:
		if c:
			c.move()
