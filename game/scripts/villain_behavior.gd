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


func _ready() -> void:
	blocked_tile_ids = self.get_meta("blocked_tile_ids")
	pos = self.position;
	timer = get_node(self.get_meta("damage_timer"))
	damage_sprite = get_node(self.get_meta("damage_sprite"))
	damage_sprite.set_visible(false)
	strength = self.get_meta("strength")
	health = self.get_meta("starting_health")
	add_to_group("villains")

func _physics_process(_delta: float) -> void:
	update()



func find_nearest(x : int) -> int:
	var angles = [0, 0.5, 1, -0.5]
	var nearest = 0
	
	for n in angles:
		if abs(x - n) < abs(x - nearest):
			nearest = n
	
	return nearest

func move() -> void:
	var vectToPlayer = player_node.position - self.position
	var angle_to_face = atan2(vectToPlayer.y, vectToPlayer.x) / PI
	print(find_nearest(angle_to_face))
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
