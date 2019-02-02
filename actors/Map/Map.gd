extends Node2D

var Territory = load("res://classes/Territory.gd")

export(bool) var locked_on_load = true

var locked = true setget set_locked
var selected_territory

func _ready():
	if locked_on_load:
		locked = true

func clear():
	selected_territory = null
	$HexGrid.clear()
	for territory in $Territories.get_children():
		territory.queue_free()
	locked = locked_on_load

func set_locked(value):
	locked = value

func add_tile(tile):
	if (tile.has_territory()):
		var territory = Territory.new(tile)
		territory.connect("selected", self, "on_territory_selected", [territory])
		$Territories.add_child(territory)
	else:
		$Others.add_child(tile)
	tile.connect("input_event", self, "on_tile_input_event", [tile])
	$HexGrid.add_node(tile)

func on_territory_selected(territory):
	if (locked):
		return

	if selected_territory:
		selected_territory.set_selected(false)
	selected_territory = territory
	territory.set_selected(true)

func on_tile_input_event(event, tile):
	if event.is_action_pressed("territory_expand"):
		if (selected_territory and selected_territory.type == selected_territory.TYPE.PLAYER):
			if (selected_territory.is_neighbour(tile)):
				selected_territory.grow(tile)