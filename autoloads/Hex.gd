extends Node

enum DIR {
	DIR_E,
	DIR_NE,
	DIR_NW,
	DIR_W,
	DIR_SW,
	DIR_SE
}

const OFFSETS = [
	Vector3(1, -1, 0),
	Vector3(1, 0, -1), 
	Vector3(0, 1, -1), 
	Vector3(-1, 1, 0), 
	Vector3(-1, 0, 1), 
	Vector3(0, -1, 1)
]

static func hex(axial):
	var x = axial.x
	var z = axial.y
	return Vector3(x, -x - z, z)

static func get_dir_between(hex_a, hex_b):
	return get_dir(hex_b - hex_a)

static func get_dir(offset):
	var dir = OFFSETS.find(offset)
	if dir == -1:
		printerr(str(offset) + " isn't a valid direction")
	return dir

static func get_opposite_dir(dir):
	return (dir + 3) % 6

static func axial(hex):
	return Vector2(hex.x, hex.z)

static func neighbour(hex, dir):
	return hex + OFFSETS[dir]

static func neighbours(hex):
	var hexes = Array()
	for offset in OFFSETS:
		hexes.append(hex + offset)
	return hexes

static func circle(hex, r):
	var hexes = Array()
	for x in range(-r, r + 1):
		for y in range(max(-r, -x-r), min(r, -x+r) + 1):
			hexes.append(hex + Vector3(x, y, -x-y))
	return hexes

static func rect(hex, w, h):
	var hexes = Array()
	for q in range(- w / 2, w / 2 + 1):
		for r in range(- h / 2, h / 2 + 1):
			hexes.append(hex + hex(Vector2(q - ceil(r / 2.0), r)))
	return hexes

static func distance(hex_a, hex_b):
	return (abs(hex_b.x - hex_a.x) + abs(hex_b.y - hex_a.y) + abs(hex_b.z - hex_a.z))