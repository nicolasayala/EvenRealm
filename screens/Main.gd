extends Node

func _ready():
	$Map/MapGenerator.connect("tile_generated", $Map, "add_tile")
	$Map/MapGenerator.connect("tile_generated", $Map/TerritoryManager, "on_tile_added")
	$Map.connect("territory_added", $Map/TerritoryManager, "on_territory_added")
	$Map/MapGenerator.connect("generation_start", $Map/TerritoryManager, "set_locked", [true])
	$Map/MapGenerator.connect("generation_end", $Map/TerritoryManager, "set_locked", [false])
	$Map/MapGenerator.connect("generation_end", $TurnManager, "start_player_turn")

func _input(event):
	if event.is_action_pressed("gen_map"):
		$Map/TerritoryManager.reset()
		$Map.clear()
		$Map/MapGenerator.start()
