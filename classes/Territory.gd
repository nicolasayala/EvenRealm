extends Node

signal changed
signal selected

var tiles = Array()
var selected = true
var type

func _init(t):
	type = t

func add(tile):
	tile.territory = self
	tiles.append(tile)

func remove(tile):
	tile.territory = null
	tiles.erase(tile)

func merge_with(territory):
	if (territory == self):
		return
	if (self.size() >= territory.size()):
		for tile in territory.tiles:
			add(tile)
	else:
		territory.merge_with(self)

func grow(tile):
	if (tile.territory):
		tile.territory.remove(tile)
	add(tile)
	tile.set_type(self.type)

func set_selected(value):
	for tile in tiles:
		tile.set_selected(value)

func has(tile):
	return tiles.has(tile)

func size():
	return tiles.size()
