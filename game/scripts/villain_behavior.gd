extends CharacterBody2D

var pos = Vector2(0, 0)
var strength
var health
var damage_sprite : Sprite2D
var timer : Timer

func _ready() -> void:
	pos = self.position;
	timer = get_node(self.get_meta("damage_timer"))
	damage_sprite = get_node(self.get_meta("damage_sprite"))
	damage_sprite.set_visible(false)
	strength = self.get_meta("strength")
	health = self.get_meta("starting_health")
	add_to_group("villains")

func _physics_process(delta: float) -> void:
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
