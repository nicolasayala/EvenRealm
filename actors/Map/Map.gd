extends Node2D

var Territory = load("res://classes/Territory.gd")

export(bool) var locked_on_load = true

var selected_territory = null
var locked = true setget set_locked

func _ready():
	if locked_on_load:
		locked = true

func clear():
	$HexGrid.clear()
	selected_territory = null
	locked = locked_on_load

func set_locked(value):
	locked = value

func add_tile(tile):
	$Territories.add_child(tile)
	tile.connect("input_event", self, "_on_tile_input_event", [tile])
	$HexGrid.add_node(tile)

func select_territory(tile):
	if (!tile.territory):
		return

	if (selected_territory):
		selected_territory.set_selected(false)
	selected_territory = tile.territory
	tile.territory.set_selected(true)

func _on_tile_input_event(event, tile):
	if (locked):
		return

	if event.is_action_pressed("tile_select"):
		select_territory(tile)
	elif event.is_action_pressed("territory_expand"):
		for neighbour in tile.get_neighbours():
			if (neighbour.type == neighbour.TILE_TYPE.ALIEN):
				neighbour.territory.grow(tile)