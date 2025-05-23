extends CharacterBody2D

var pos = Vector2(0, 0)

func _ready() -> void:
	pos = self.position;
	add_to_group("villains")

func moveUp() -> void:
	pos.y -= 32;
