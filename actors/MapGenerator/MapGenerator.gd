extends Node

signal generation_end()
signal tile_generated(tile)

export (PackedScene) var Tile

export(bool) var gen_on_load = false
export(int, 0, 100) var tiles_per_tick = 1

var hexes
var generating = false
var start_time = 0

func _ready():
	set_process(false)
	if gen_on_load:
		start()

func _process(delta):
	for i in range(0, tiles_per_tick):
		generating = !hexes.empty()
		if (!generating):
			set_process(false)
			print("Done generating ! " + str(OS.get_ticks_msec() - start_time) + "ms")
			emit_signal("generation_end")
			return
		gen_tile(hexes.front())
		hexes.pop_front()

func start():
	if generating:
		return
	start_time = OS.get_ticks_msec()
	generating = true
	set_process(true)
	hexes = Hex.rect(Vector3(0, 0, 0), 50, 48)
	if tiles_per_tick == 0:
		tiles_per_tick = hexes.size()
	print("Generating " + str(hexes.size()) + " tiles...")

func gen_tile(hex):
	var r = randf()
	var tile = Tile.instance()
	if hex == Vector3(0, 0, 0):
		tile.set_type(tile.TYPE.ALIEN)
	elif (r > Hex.distance(Vector3(0, 0, 0), hex) / 45):
		tile.set_type(tile.TYPE.GRASS)
	else:
		tile.set_type(tile.TYPE.WATER)
	tile.hex = hex
	emit_signal("tile_generated", tile)