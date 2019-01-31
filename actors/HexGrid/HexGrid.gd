extends Node2D

export (PackedScene) var HexVoid
export (PackedScene) var HexGrass
export (PackedScene) var HexWater
export (PackedScene) var HexSand
export (PackedScene) var HexAlien

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

var grid = Dictionary()
var selected_region = Array()

func _ready():
	set_hex_scale(hex_scale)
	var hex = add_hex(Vector3(0, 0, 0))
	for coord in hex.get_rect(50, 48): ##fullscreen 50/48
		add_hex(coord)
	update_hexes_tiles()

func add_hex(coords):
	if (grid.has(coords)):
		return

	var hex
	var r = randf()
	if (r > 0.95):
		hex = HexAlien.instance()
	elif (r > 0.45):
		hex = HexGrass.instance()
	else:
		hex = HexWater.instance()
	hex.set_cube_coords(coords)
	hex.size = hex_size
	hex.position = get_hex_center(hex)
	add_child(hex)
	grid[coords] = hex
	hex.connect("selected", self, "hex_selected", [hex])
	hex.connect("hover", self, "hex_hover", [hex])
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

func update_hexes_tiles():
	for hex in grid.values():
		hex.set_id(compute_hex_id(hex))

func compute_hex_id(hex):
	var id = 0
	var n = 1
	var hex_type = hex.type
	for coord in hex.get_adjacents():
		if grid.has(coord):
			var other_type = grid[coord].type
			if other_type != hex_type :
				id += n
		else:
			id += n
		n *= 2
	return id

func hex_selected(hex):
	for h in selected_region:
		h.set_selected(false)
	
	selected_region = flood_fill(hex)
	for h in selected_region:
		h.set_selected(true)

func get_neighbours(hex):
	var neighbours = Array()
	for coord in hex.get_adjacents():
		if grid.has(coord):
			neighbours.append(grid[coord])
	return neighbours

func flood_fill(origin_hex):
	var type = origin_hex.type
	var queue = Array()
	var visited = Array()
	visited.push_back(origin_hex)
	queue.push_back(origin_hex)
	while !queue.empty():
		var hex = queue.front()
		queue.pop_front()
		for other in get_neighbours(hex):
			if other.type == type && !visited.has(other):
				visited.push_back(other)
				queue.push_back(other)
	return visited

func hex_hover(hex):
	$Selector.position = hex.position