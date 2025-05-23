extends CharacterBody2D

var pos = Vector2(0, 0)
var strength
var health

func _ready() -> void:
	pos = self.position;
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
	health -= dmg
