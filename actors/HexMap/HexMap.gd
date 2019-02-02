extends Node2D

export(bool) var locked_on_load = true

var Territory = load("res://classes/Territory.gd")
var selected_territory = Territory.new()
var locked = true setget set_locked

func _ready():
	if locked_on_load:
		locked = true

func set_locked(value):
	locked = value

func add_tile(tile):
	$HexGrid.add_node(tile, funcref(tile, "initialize"))

func select_tile(tile):
	$HexGrid/Selector.position = tile.position

func select_territory(tile):
	if (!tile.territory):
		return

	if (selected_territory):
		selected_territory.set_selected(false)
	selected_territory = tile.territory
	tile.territory.set_selected(true)

func _on_HexGrid_node_input_event(event, tile):
	if (locked):
		return

	if event.is_action_pressed("tile_select"):
		select_territory(tile)
	elif event.is_action_pressed("territory_expand"):
		for neighbour in tile.get_neighbours():
			if (neighbour.type == neighbour.TILE_TYPE.ALIEN):
				neighbour.territory.grow(tile)
				print("grow")
	elif event is InputEventMouseMotion:
		select_tile(tile)