extends Node2D

signal territory_added(territory)

var Territory = load("res://classes/Territory.gd")

func clear():
	$HexGrid.clear()
	for territory in $Territories.get_children():
		territory.queue_free()

func add_tile(tile):
	var territory = Territory.new(tile)
	$Territories.add_child(territory)
	emit_signal("territory_added", territory)
	$HexGrid.add_node(tile)

#func on_tile_input_event(event, tile):
#	if event.is_action_pressed("territory_expand"):
#		if (selected_territory and selected_territory.type == selected_territory.TYPE.PLAYER):
#			if (selected_territory.is_neighbour(tile)):
#				selected_territory.grow(tile)