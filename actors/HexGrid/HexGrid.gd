extends Node2D

export(Vector2) var node_size = Vector2(12, 10)
var node_transform
var node_transform_inv

var grid = Dictionary()

func get_nodes():
	return grid.values()

func _ready():
	node_transform = Transform2D(
		Vector2(node_size.x, 0),
		Vector2(node_size.x / 2, int(0.7 * node_size.y)),
		Vector2(0, 0)
	)
	node_transform_inv = node_transform.affine_inverse()

func clear():
	for node in grid.values():
		node.queue_free()
	grid = Dictionary()

var i = 0
func add_node(node):
	var hex = node.hex
	if (hex == null):
		printerr("Can't add node with null hex")
		return false
	if (grid.has(hex)):
		printerr("GridMap already has node at " + str(hex))
		return false
	grid[hex] = node
	node.position = get_node_center(hex)
	for other in get_neighbours(node):
		var dir = Hex.get_dir_between(node.hex, other.hex)
		node.set_neighbour(other, dir)
	return true

func remove_node(node):
	if (!grid.has(node.hex)):
		return
	grid[node.hex].queue_free()
	grid.erase(node.hex)

func get_node_center(hex):
	return node_transform * Hex.axial(hex)

func get_neighbours(node, with_nulls=false):
	var nodes = Array()
	for hex in Hex.neighbours(node.hex):
		if grid.has(hex):
			nodes.append(grid[hex])
		elif with_nulls:
			nodes.append(null)
	return nodes

#func flood_fill(node, mask_func):
#	var queue = Array()
#	var visited = Array()
#	visited.push_back(node)
#	queue.push_back(node)
#	while !queue.empty():
#		var n = queue.front()
#		queue.pop_front()
#		for other in get_neighbours(n):
#			if !mask_func.call_func(other) && !visited.has(other):
#				visited.push_back(other)
#				queue.push_back(other)
#	return visited

func _input(event):
	var mouse_local = get_local_mouse_position();
	var hex = Hex.round(Hex.cube(node_transform_inv * mouse_local))
	if grid.has(hex):
		grid[hex].input_event(event)