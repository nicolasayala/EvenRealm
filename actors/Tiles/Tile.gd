extends "res://actors/HexGrid/HexGridNode.gd"

var Territory = load("res://classes/Territory.gd")

var TEXTURES = [
	null,
	preload("res://assets/raw/tiles/tilesheet_water.png"),
	preload("res://assets/raw/tiles/tilesheet_grass.png"),
	preload("res://assets/raw/tiles/tilesheet_sand.png"),
	preload("res://assets/raw/tiles/tilesheet_alien.png")
]

enum TYPE {
	VOID,
	WATER,
	GRASS,
	SAND,
	ALIEN
}

export (TYPE) var type = VOID setget set_type
export (bool) var gen_territory = true
var id = 0 setget set_id
var selected = false setget set_selected

func set_neighbour(tile, dir):
	.set_neighbour(tile, dir)
	if (self.type == tile.type):
		if (self.has_territory() and tile.has_territory()):
			tile.get_territory().merge_with(self.get_territory())
	update_id()
	tile.update_id()

func get_territory():
	return get_parent()

func has_territory():
	return gen_territory

func set_id(n):
	id = n
	if (is_inside_tree()):
		$Sprite.set_tile_id(id)
		$Borders.set_tile_id(id)

func update_id():
	var id = 0
	var n = 1
	for other in neighbours:
		if other != null:
			if other.type != self.type:
				id += n
		else:
			id += n
		n *= 2
	set_id(id)

func set_selected(value):
	selected = value
#	if (value):
#		$Sprite.modulate = Color(0.1, 0.1, 0.1)
#	else:
#		$Sprite.modulate = Color(1, 1, 1)
	$Borders.visible = value

func set_type(t):
	type = t
	if (is_inside_tree()):
		$Sprite.texture = TEXTURES[type]
	for tile in self.get_neighbours():
		tile.update_id()
	self.update_id()

func _on_Area_input_event(viewport, event, shape_idx):
	emit_signal("input_event", event)

