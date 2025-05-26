extends Node


var villain_scene
var player
var tilemaplayer
var army = []
var enemyTargetPos = []
var enemyCurrentPos = []

func _ready() -> void:
	villain_scene = get_meta("villain_scene")
	tilemaplayer = get_node(get_meta("tilemap_layer"))
	player = get_node(get_meta("player"))
	spawnArmy(4, 2)


func spawnArmy(rows, columns) -> void:
	var counter = 0
	for i in range(rows):
		for j in range(columns):
			if j % 2 == 0:
				continue
			var villain = villain_scene.instantiate()
			villain.position = Vector2(32 * j + 832, 32 * i);
			army.append(villain)
			add_child(villain)
			villain.myIndex = counter
			villain.connect("nextPos", Callable(self, "_updateNextPos"))
			counter += 1
			enemyTargetPos.append(villain.position)
			enemyCurrentPos.append(villain.position)

func _updateNextPos(target, enemyIndex, currentPos, enemy):
	var canMove = true
	
	for i in range(len(enemyTargetPos)):
		if i == enemyIndex:
			continue
		if target == enemyTargetPos[i] or target == enemyCurrentPos[i]:
			canMove = false
			enemy.path[0] = enemy.position
	
	enemy.canMove = canMove
		
	enemyTargetPos[enemyIndex] = target
	enemyCurrentPos[enemyIndex] = currentPos
		
	
	
