extends Node2D

var Hex = preload("./Hex.tscn")

export (Texture) var grass 
export (Texture) var water

const DIR_E = Vector3(1, -1, 0)
const DIR_NE = Vector3(1, 0, -1)
const DIR_NW = Vector3(0, 1, -1)
const DIR_W = Vector3(-1, 1, 0)
const DIR_SW = Vector3(-1, 0, 1)
const DIR_SE = Vector3(0, -1, 1)
const DIR_ALL = [DIR_E, DIR_NE, DIR_NW, DIR_W, DIR_SW, DIR_SE]

export(float) var hex_scale = 1.0
export(Vector2) var base_hex_size = Vector2(12, 10)
var hex_size
var hex_transform
var hex_transform_inv

func _ready():
	set_hex_scale(hex_scale)
	var hex = add_hex(Vector3(0, 0, 0))
	for coord in hex.get_rect(50, 48): ##54/52
		add_hex(coord)

func add_hex(coords):
	var hex = Hex.instance()
	if (randf() > 0.66):
		hex.get_node("Sprite").texture = grass
	else:
		hex.get_node("Sprite").texture = water
	hex.set_cube_coords(coords)
	hex.size = hex_size
	hex.position = get_hex_center(hex)
	add_child(hex)
	return hex

func set_hex_scale(scale):
	hex_scale = scale
	hex_size = base_hex_size * hex_scale
	hex_transform = Transform2D(
		Vector2(hex_size.x, 0),
		Vector2(hex_size.x / 2, int(0.7 * hex_size.y)),
		Vector2(0, 0)
	)
	hex_transform_inv = hex_transform.affine_inverse()
	
func get_hex_center(hex):
	return hex_transform * hex.axial_coords
