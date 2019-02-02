signal changed
signal selected

var tiles = Array()
var selected = true
var type

func _init():
	pass

func add(tile):
	if (tiles.has(tile)):
		return
	if (!type):
		type = tile.type
	tile.territory = self
	tiles.append(tile)

func remove(tile):
	tile.territory = null
	tiles.erase(tile)

func merge_with(territory):
	if (territory == self):
		return
	for tile in territory.tiles:
		add(tile)

func grow(tile):
	if (tile.territory):
		tile.territory.remove(tile)
	add(tile)
	print("setting type to " + str(self.type))
	tile.set_type(self.type)

func set_selected(value):
	for tile in tiles:
		tile.set_selected(value)

func has(tile):
	return tiles.has(tile)
