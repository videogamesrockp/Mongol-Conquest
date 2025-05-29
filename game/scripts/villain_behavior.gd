extends CharacterBody2D

var pos = Vector2(0, 0)
var strength
var health
const TILE_SIZE = 32
var canMove = true
var speed

var player : Node2D
var tilemap_layer : Node
var path : Array = []
var moving := false
var blocked_tile_ids : Array
var myIndex
var damageSprite
signal enemy_died(index)

signal nextPos(target: Vector2, enemyIndex: int, currentPos: Vector2, enemy: Node)
func emitNextTarget():
	var target
	if len(path) > 0:
		target = Vector2(path[0].x * TILE_SIZE, path[0].y * TILE_SIZE)
	else:
		target = self.position
	emit_signal("nextPos", target, myIndex, self.position, self)

func _ready() -> void:
	speed = get_meta("speed")
	damageSprite = get_meta("damage_sprite")
	pos = self.position
	strength = self.get_meta("strength")
	health = self.get_meta("starting_health")
	add_to_group("villains")
	
	var enemy_army = get_parent()
	player = enemy_army.player
	tilemap_layer = enemy_army.tilemaplayer
	blocked_tile_ids = player.get_meta("blocked_tile_ids")
	
	player.player_moved.connect(find_path_to_player)

func _physics_process(_delta: float) -> void:
	update()
	if not moving and player:
		find_path_to_player()
		emitNextTarget()
		if(canMove):
			move_along_path()
	

func find_path_to_player() -> void:
	path.clear()
	var start_pos := Vector2i(position.x / TILE_SIZE, position.y / TILE_SIZE)
	var end_pos := Vector2i(player.position.x / TILE_SIZE, player.position.y / TILE_SIZE)
	
	path = astar_pathfinding(start_pos, end_pos)

func astar_pathfinding(start: Vector2i, end: Vector2i) -> Array:
	var frontier := []
	var came_from := {}
	var cost_so_far := {}
	
	frontier.push_back(start)
	came_from[start] = null
	cost_so_far[start] = 0
	
	while not frontier.is_empty():
		var current = frontier.pop_front()
		
		if current == end:
			break
			
		for next in get_neighbors(current):
			var new_cost = cost_so_far[current] + 1
			
			if not cost_so_far.has(next) or new_cost < cost_so_far[next]:
				cost_so_far[next] = new_cost
				var priority = new_cost + manhattan_distance(next, end)
				frontier.push_back(next)
				frontier.sort_custom(func(a, b): return manhattan_distance(a, end) < manhattan_distance(b, end))
				came_from[next] = current
	
	var path_array := []
	var current = end
	
	while current != start:
		if not came_from.has(current):
			return []
		path_array.push_front(current)
		current = came_from[current]
	
	return path_array

func get_neighbors(pos: Vector2i) -> Array:
	var neighbors := []
	var directions := [Vector2i(0, 1), Vector2i(1, 0), Vector2i(0, -1), Vector2i(-1, 0)]
	
	for dir in directions:
		var next = pos + dir
		if is_valid_tile(next):
			neighbors.append(next)
	
	return neighbors

func is_valid_tile(pos: Vector2i) -> bool:
	if tilemap_layer:
		var tile_id = tilemap_layer.get_cell_source_id(pos)
		return not (tile_id in blocked_tile_ids)
	return true

func manhattan_distance(a: Vector2i, b: Vector2i) -> int:
	return abs(a.x - b.x) + abs(a.y - b.y)

func move_along_path() -> void:
	if path.is_empty():
		return
		
	var next_point = path[0]
	var target_pos = Vector2(next_point.x * TILE_SIZE, next_point.y * TILE_SIZE)
	
	if position.distance_to(target_pos) < 1:
		path.pop_front()
		return
	
	moving = true
	var tween = create_tween()
	tween.tween_property(self, "position", target_pos, speed)  # Slower movement - takes 0.75 seconds per tile
	tween.tween_callback(func(): moving = false)

func update() -> void:
	if (health <= 0):
		emit_signal("enemy_died", myIndex)

		self.queue_free()
	
func take_damage(dmg: int) -> void:
	health -= dmg
	if health < 50:
		$Sprite.texture = damageSprite
