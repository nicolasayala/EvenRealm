extends Node2D

signal selected

enum HEX_TYPE {
	VOID,
	WATER,
	GRASS,
	SAND,
	ALIEN
}
export (HEX_TYPE) var type = VOID
var id = 0 setget set_id
var selected = false setget set_selected

const DIR_E = Vector3(1, -1, 0)
const DIR_NE = Vector3(1, 0, -1)
const DIR_NW = Vector3(0, 1, -1)
const DIR_W = Vector3(-1, 1, 0)
const DIR_SW = Vector3(-1, 0, 1)
const DIR_SE = Vector3(0, -1, 1)
const DIR_ALL = [DIR_E, DIR_NE, DIR_NW, DIR_W, DIR_SW, DIR_SE]

export (Vector2) var size = Vector2(1, 1)

export (Vector3) var cube_coords = Vector3(0, 0, 0) setget set_cube_coords, get_cube_coords
var axial_coords setget set_axial_coords, get_axial_coords

func obj_to_cube_coords(o):
	match typeof(o):
		TYPE_VECTOR3:
			return o
		TYPE_VECTOR2:
			return axial_to_cube_coords(o)
		TYPE_OBJECT:
			if (o.has_method("get_cube_coords")):
				return o.get_cube_coords()
	return null

func axial_to_cube_coords(coords):
	var x = coords.x
	var z = coords.y
	return Vector3(x, -x - z, z)

func get_cube_coords():
	return cube_coords

func set_cube_coords(coords):
	if (coords.x + coords.y + coords.z != 0):
		print("Invalid cube coordinates for hex ("+ str(coords.x) + ", " + str(coords.y) + ", " + str(coords.z) + ")")
	cube_coords = coords

func get_axial_coords():
	return Vector2(cube_coords.x, cube_coords.z)

func set_axial_coords(coords):
	set_cube_coords(axial_to_cube_coords(coords))

func get_adjacent(dir):
	obj_to_cube_coords(dir)
	return cube_coords + dir

func get_adjacents():
	var coords = Array()
	for dir in DIR_ALL:
		coords.append(cube_coords + dir)
	return coords

func get_range(r):
	var coords = Array()
	for x in range(-r, r + 1):
		for y in range(max(-r, -x-r), min(r, -x+r) + 1):
			coords.append(cube_coords + Vector3(x, y, -x-y))
	return coords

func get_rect(w, h):
	var coords = Array()
	for q in range(- w / 2, w / 2 + 1):
		for r in range(- h / 2, h / 2 + 1):
			coords.append(cube_coords + axial_to_cube_coords(Vector2(q - ceil(r / 2.0), r)))
	return coords

func set_id(n):
	id = n
	$Tile.set_tile_id(id)
	$Selection.set_tile_id(id)

func set_selected(s):
	selected = s
	$Selection.visible = selected

func _on_Area_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("hex_select"):
		emit_signal("selected")
