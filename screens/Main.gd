extends Node

func _ready():
	$MapGenerator.connect("tile_generated", $Map, "add_tile")
	$MapGenerator.connect("generation_end", $Map, "set_locked", [false])
	$MapGenerator.start()

func _input(event):
	if event.is_action_pressed("gen_map"):
		$Map.clear()
		$MapGenerator.start()
