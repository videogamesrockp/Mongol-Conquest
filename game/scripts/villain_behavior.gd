extends CharacterBody2D

var pos = Vector2(0, 0)
var strength
var health
var damage_sprite : Sprite2D
var timer : Timer
const TILE_SIZE = 32

# Pathfinding variables
var player : Node2D
var tilemap_layer : Node
var path : Array = []
var moving := false
var blocked_tile_ids : Array
var last_moved = false

func _ready() -> void:
	pos = self.position
	timer = get_node(self.get_meta("damage_timer"))
	damage_sprite = get_node(self.get_meta("damage_sprite"))
	damage_sprite.set_visible(false)
	strength = self.get_meta("strength")
	health = self.get_meta("starting_health")
	add_to_group("villains")
	
	# Get references for pathfinding
	var enemy_army = get_parent()
	player = enemy_army.player
	tilemap_layer = enemy_army.tilemaplayer
	blocked_tile_ids = player.get_meta("blocked_tile_ids")

func _physics_process(_delta: float) -> void:
	if last_moved:
		last_moved = false
		pass
	else:
		update()
		if not moving and player:
			find_path_to_player()
			move_along_path()
		last_moved = true

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
	
	# Reconstruct path
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
	tween.tween_property(self, "position", target_pos, 0.25)
	tween.tween_callback(func(): moving = false)

func update() -> void:
	if (health <= 0):
		self.queue_free()
	
func take_damage(dmg: int) -> void:
	damage_sprite.set_visible(true)
	timer.start()
	health -= dmg

func _on_damage_timer() -> void:
	damage_sprite.set_visible(false)
	timer.stop()
