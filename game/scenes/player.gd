extends CharacterBody2D

var pos = [0, 0]

func _input(event):
	if event.is_action_pressed("ui_right"):
		pos[0] += 32
	elif event.is_action_pressed("ui_left"):
		pos[0] -= 32;
	elif event.is_action_pressed("ui_up"):
		pos[1] -= 32
	elif event.is_action_pressed("ui_down"):
		pos[1] += 32;
	self.position = Vector2(pos[0], pos[1])
