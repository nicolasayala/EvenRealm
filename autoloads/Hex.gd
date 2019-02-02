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

static func cube(axial):
	return Vector3(axial.x, -axial.x - axial.y, axial.y)

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
	for r in range(- h / 2, h / 2 + 1):
		for q in range(- w / 2, w / 2 + 1):
			hexes.append(hex + hex(Vector2(q - ceil(r / 2.0), r)))
	return hexes

func round(hex):
	var rounded = Vector3(round(hex.x), round(hex.y), round(hex.z))
	var diffs = (rounded - hex).abs()
	if diffs.x > diffs.y and diffs.x > diffs.z:
		rounded.x = -rounded.y - rounded.z
	elif diffs.y > diffs.z:
		rounded.y = -rounded.x - rounded.z
	else:
		rounded.z = -rounded.x - rounded.y
	return rounded

static func distance(hex_a, hex_b):
	return (abs(hex_b.x - hex_a.x) + abs(hex_b.y - hex_a.y) + abs(hex_b.z - hex_a.z))