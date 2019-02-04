extends Node2D

signal selected

enum TYPE {
	PLAYER,
	IA,
	NONE	
}

var type
var selected

func _init(tile):
	if tile.type == tile.TYPE.ALIEN:
		type = PLAYER
	elif tile.type == tile.TYPE.WATER:
		type = NONE
	else:
		type = IA
	add_tile(tile)

func add_tile(tile):
	add_child(tile)
	tile.connect("input_event", self, "on_tile_input_event", [tile])

func merge_with(territory):
	if (territory == self):
		return
	if (self.size() >= territory.size()):
		for tile in territory.get_tiles():
			tile.get_parent().remove_child(tile)
			add_tile(tile)
			territory.queue_free()
	else:
		territory.merge_with(self)

func grow(tile):
	tile.get_parent().remove_child(tile)
	add_tile(tile)
	tile.set_type(tile.TYPE.ALIEN)
	if (selected):
		set_selected(true)

func set_selected(value):
	selected = value
	for tile in get_tiles():
		tile.set_selected(value)

func has(tile):
	return get_tiles().has(tile)

func size():
	return get_tiles().size()

func get_tiles():
	return get_children()

func on_tile_input_event(event, tile):
	if event.is_action_pressed("territory_select"):
		emit_signal("selected")

func is_neighbour(tile):
	var tiles = get_tiles()
	if (tiles.has(tile)):
		return false
	for neighbour in tile.get_neighbours():
		if tiles.has(neighbour):
			return true
	return false
