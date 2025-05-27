extends TileMapLayer

func _ready() -> void:
	add_to_group("tilemap")

func get_tileid_from_pos(world_pos: Vector2) -> int:
	var local_pos = transform.affine_inverse() * world_pos
	var cell_coords = Vector2i(floor(local_pos.x / 32), floor(local_pos.y / 32))
	return get_cell_source_id(cell_coords)
