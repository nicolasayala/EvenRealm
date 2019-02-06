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
	$HexGrid.add_node(tile)

func init_territories():
	for territory in get_territories():
		emit_signal("territory_added", territory)

func get_territories():
	return $Territories.get_children()

func get_tiles():
	return $HexGrid.get_nodes()