extends Node2D

signal node_hovered(node)
signal node_selected(node)

export(Vector2) var node_size = Vector2(12, 10)
var node_transform

var grid = Dictionary()

func _ready():
	node_transform = Transform2D(
		Vector2(node_size.x, 0),
		Vector2(node_size.x / 2, int(0.7 * node_size.y)),
		Vector2(0, 0)
	)

func add_node(hex, scene):
	if (grid.has(hex)):
		return
	var node = scene.instance()
	
	node.hex = hex
	node.position = get_node_center(hex)
	add_child(node)
	grid[hex] = node
	node.connect("selected", self, "_node_selected", [node])
	node.connect("hover", self, "_node_hovered", [node])

func get_node_center(hex):
	return node_transform * Hex.axial(hex)

func update_nodes():
	for node in grid.values():
		node.set_id(compute_node_id(node))

func compute_node_id(node):
	var hex = node.hex
	var id = 0
	var n = 1
	var node_type = node.type
	for other in Hex.neighbours(hex):
		if grid.has(other):
			var other_type = grid[other].type
			if other_type != node_type :
				id += n
		else:
			id += n
		n *= 2
	return id

func get_neighbours(node):
	var nodes = Array()
	for hex in Hex.neighbours(node.hex):
		if grid.has(hex):
			nodes.append(grid[hex])
	return nodes

func flood_fill(node):
	var node_type = node.type
	var queue = Array()
	var visited = Array()
	visited.push_back(node)
	queue.push_back(node)
	while !queue.empty():
		var n = queue.front()
		queue.pop_front()
		for other in get_neighbours(n):
			if other.type == node_type && !visited.has(other):
				visited.push_back(other)
				queue.push_back(other)
	return visited

func _node_selected(node):
	emit_signal("node_selected", node)

func _node_hovered(node):
	emit_signal("node_hovered", node)