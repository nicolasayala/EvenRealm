tool
extends Node2D

var debug_color = Color(1,1,1)

func _process(delta):
	update()

func _draw():
	for i in range(6):
		draw_line(hex_corner(i), hex_corner((i + 1) % 6), debug_color)

func hex_corner(i):
	match i:
		0:
			return Vector2(6, 2)
		1:
			return Vector2(6, -2)
		2:
			return Vector2(0, -5)
		3:
			return Vector2(-6, -2)
		4:
			return Vector2(-6, 2)
		5:
			return Vector2(0, 5)

func _on_Area_mouse_entered():
	debug_color = Color(1, 0, 0)
	z_index = 2

func _on_Area_mouse_exited():
	debug_color = Color(1, 1, 1)
	z_index = 1