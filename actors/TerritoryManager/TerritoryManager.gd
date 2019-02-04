extends Node2D

signal territory_selected(territory)

export(bool) var locked_on_load = true

var locked = true setget set_locked
var selected_territory

func _ready():
	set_locked(locked_on_load)

func set_locked(value):
	locked = value
	$Selector.visible = !locked

func reset():
	selected_territory = null

func on_territory_added(territory):
	territory.connect("selected", self, "on_territory_selected", [territory])

func on_tile_added(tile):
	tile.connect("input_event", self, "on_tile_input_event", [tile])

func on_territory_selected(territory):
	if (locked or territory.type == territory.TYPE.NONE):
		return
		
	if selected_territory:
		selected_territory.set_selected(false)
	selected_territory = territory
	territory.set_selected(true)
	emit_signal("territory_selected", territory)

func on_tile_input_event(event, tile):
	$Selector.position = tile.position