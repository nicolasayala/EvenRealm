extends Node

func _ready():
	$Map/MapGenerator.connect("tile_generated", $Map, "add_tile")
	$Map/MapGenerator.connect("tile_generated", $Map/TerritorySelector, "on_tile_added")
	$Map.connect("territory_added", $Map/TerritorySelector, "on_territory_added")
	$Map/MapGenerator.connect("generation_start", $Map/TerritorySelector, "set_locked", [true])
	$Map/MapGenerator.connect("generation_end", $Map, "init_territories")
	$Map/MapGenerator.connect("generation_end", $Map/TerritorySelector, "set_locked", [false])
	
	$Map/TerritorySelector.connect("territory_selected", $CanvasLayer/InfoPanel/MarginContainer/VBoxContainer/TerritoryInfo, "set_values")
	
	$Map/MapGenerator.connect("generation_end", $TurnManager, "start_player_turn")

func _input(event):
	if event.is_action_pressed("gen_map"):
		$Map/TerritorySelector.reset()
		$Map.clear()
		$Map/MapGenerator.start()
	elif event.is_action_pressed("draw_map"):
		$CanvasLayer/InfoPanel/MarginContainer/VBoxContainer/MapIcon.init($Map, $Camera)
