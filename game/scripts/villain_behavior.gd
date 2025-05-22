extends CharacterBody2D

var pos = Vector2(0, 0)

func _ready() -> void:
	pos = self.position;

func moveUp() -> void:
	pos.y -= 32;
