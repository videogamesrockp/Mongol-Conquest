extends CharacterBody2D

const tile_size = 32
var moving = false
var input_dir = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if is_colliding_with_enemy():
		print("⚠️ Currently getting hit by an enemy at " + str(position.x) + ", " + str(position.y))
	
	if moving:
		return
	
	input_dir = Vector2.ZERO
	if Input.is_action_pressed("ui_down"):
		input_dir.y = 1
	elif Input.is_action_pressed("ui_up"):
		input_dir.y = -1
	if Input.is_action_pressed("ui_right"):
		input_dir.x = 1
	elif Input.is_action_pressed("ui_left"):
		input_dir.x = -1

	if input_dir != Vector2.ZERO:
		move()

func move():
	var motion = input_dir * tile_size

	# Check for potential collision
	#if test_move(transform, motion):
		#print("⚠️ Collision would occur at: ", position + motion)

	moving = true
	var tween = create_tween()
	tween.tween_property(self, "position", position + motion, 0.25)
	tween.tween_callback(Callable(self, "move_false"))

func move_false():
	moving = false


func is_colliding_with_enemy() -> bool:
	var space_state = get_world_2d().direct_space_state
	var shape = $CollisionShape2D.shape

	var shape_query = PhysicsShapeQueryParameters2D.new()
	shape_query.shape = shape
	shape_query.transform = global_transform
	shape_query.collision_mask = collision_mask 
	shape_query.collide_with_bodies = true
	shape_query.collide_with_areas = true

	var results = space_state.intersect_shape(shape_query, 1)
	for result in results:
		if result.collider.is_in_group("villains"):
			return true
		else:
			print("we have collided with something else (likely a brick)")
	return false
