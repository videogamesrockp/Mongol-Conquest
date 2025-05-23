extends CharacterBody2D

var pos = Vector2(0, 0)
var strength
var health
var damage_sprite : Sprite2D
var timer : Timer
const TILE_SIZE = 32
const TURNS_TO_MOVE: int = 1
var blocked_tile_ids


var tilemap_layer_node: TileMapLayer = null
var player_node: CharacterBody2D = null

var pathfinding_grid: AStarGrid2D = AStarGrid2D.new()
var path_to_player: Array = []
var turn_counter: int = 1

func _ready() -> void:
	blocked_tile_ids = self.get_meta("blocked_tile_ids")
	pos = self.position;
	timer = get_node(self.get_meta("damage_timer"))
	damage_sprite = get_node(self.get_meta("damage_sprite"))
	damage_sprite.set_visible(false)
	strength = self.get_meta("strength")
	health = self.get_meta("starting_health")
	add_to_group("villains")
	
	player_node.player_did_a_move.connect(_move_ai)
	
	pathfinding_grid.region = tilemap_layer_node.get_used_rect()
	pathfinding_grid.cell_size = Vector2(TILE_SIZE, TILE_SIZE)
	pathfinding_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	pathfinding_grid.update()
	
	for cell in tilemap_layer_node.get_used_cells():
		pathfinding_grid.set_point_solid(cell, true)
		
	_move_ai()
	
func _move_ai():
	path_to_player = pathfinding_grid.get_point_path(global_position / TILE_SIZE, player_node.global_position / TILE_SIZE)
	
	if turn_counter != TURNS_TO_MOVE:
		turn_counter += 1
	else:
		if path_to_player.size() > 1:
			path_to_player.remove_at(0)
			var go_to_pos: Vector2 = path_to_player[0] + Vector2(TILE_SIZE/2.0, TILE_SIZE/2.0)
					
			global_position = go_to_pos
		
		
			turn_counter = 1

func _physics_process(_delta: float) -> void:
	update()

func move() -> void:
	pos.x -= 32;
	position = pos
		
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
