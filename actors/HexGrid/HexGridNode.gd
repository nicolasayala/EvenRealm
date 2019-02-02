extends Node2D

var hex = Vector3(0, 0, 0)
var neighbours = [null, null, null, null, null, null]

func get_neighbours(with_nulls=false):
	if (with_nulls):
		return neighbours
	else:
		var result = Array()
		for neighbour in neighbours:
			if neighbour:
				result.append(neighbour)
		return result

func set_neighbour(node, dir):
	neighbours[dir] = node
	if (node):
		node.neighbours[Hex.get_opposite_dir(dir)] = self