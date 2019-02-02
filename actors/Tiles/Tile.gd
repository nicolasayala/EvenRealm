extends "res://actors/HexGrid/HexGridNode.gd"

var Territory = load("res://classes/Territory.gd")

signal input_event(event)

var TEXTURES = [
	null,
	load("res://assets/raw/tiles/tilesheet_water.png"),
	load("res://assets/raw/tiles/tilesheet_grass.png"),
	load("res://assets/raw/tiles/tilesheet_sand.png"),
	load("res://assets/raw/tiles/tilesheet_alien.png")
]

enum TILE_TYPE {
	VOID,
	WATER,
	GRASS,
	SAND,
	ALIEN
}

export (TILE_TYPE) var type = VOID setget set_type
var id = 0 setget set_id
var selected = false setget set_selected
var territory

func _ready():
	Territory.new().add(self)

func set_neighbour(tile, dir):
	.set_neighbour(tile, dir)
	if (tile):
		if (self.type == tile.type):
			tile.territory.merge_with(self.territory)
	update_id()
	tile.update_id()

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

func update_territory():
	pass

func initialize():
	pass

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

