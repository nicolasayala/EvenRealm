extends Node

const DIR_E = Vector3(1, -1, 0)
const DIR_NE = Vector3(1, 0, -1)
const DIR_NW = Vector3(0, 1, -1)
const DIR_W = Vector3(-1, 1, 0)
const DIR_SW = Vector3(-1, 0, 1)
const DIR_SE = Vector3(0, -1, 1)
const DIR_ALL = [DIR_E, DIR_NE, DIR_NW, DIR_W, DIR_SW, DIR_SE]

static func hex(axial):
	var x = axial.x
	var z = axial.y
	return Vector3(x, -x - z, z)

static func axial(hex):
	return Vector2(hex.x, hex.z)

static func neighbour(hex, dir):
	return hex + dir

static func neighbours(hex):
	var hexes = Array()
	for dir in DIR_ALL:
		hexes.append(hex + dir)
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