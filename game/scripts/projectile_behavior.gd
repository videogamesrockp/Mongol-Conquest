extends StaticBody2D
var velocity = Vector2.ZERO
var damage

func _ready() -> void:
	damage = get_meta("damage")

func _physics_process(delta: float) -> void:
	self.position += (velocity * delta)
	collision_detection()

func set_velocity(v: Vector2 )	:
	velocity = v

func collision_detection() -> void:
	
	var space_state = get_world_2d().direct_space_state
	var shape = $CollisionShape2D.shape

	var shape_query = PhysicsShapeQueryParameters2D.new()
	shape_query.shape = shape
	shape_query.transform = global_transform
	shape_query.collision_mask = collision_mask 
	shape_query.collide_with_bodies = true
	shape_query.collide_with_areas = true

	var results = space_state.intersect_shape(shape_query)
	var hitting_enemy = null
	for result in results:
		if result.collider.is_in_group("villains"):
			print("⚠️ Hit an enemy with projectile at " + str(position.x) + ", " + str(position.y))
			hitting_enemy = result.collider
			break
	if hitting_enemy:
		hitting_enemy.take_damage(damage)
		hitting_enemy.position.x += 64
		self.queue_free()
