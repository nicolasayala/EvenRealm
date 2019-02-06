extends PanelContainer

export (Array) var colors
export (int) var width = 102
export (int) var height = 102

var img
var texture
var map
var camera

func _process(delta):
	if (map and camera):
		draw_map(map, camera)

func _ready():
	img = Image.new()
	img.create(width, height, false, Image.FORMAT_RGBA8)
	texture = ImageTexture.new()
	texture.create(width, height, Image.FORMAT_RGBA8, 0)
	texture.set_data(img)
	$MapIconTexture.set_texture(texture)
	yield(get_tree().create_timer(2.0), "timeout")

func init(m, c):
	map = m
	camera = c

func draw_map(map, camera):
	img.create(width, height, false, Image.FORMAT_RGBA8)
	img.lock()
	for tile in map.get_tiles():
		draw_tile(tile)
	draw_camera(camera)
	img.unlock()
	texture.set_data(img)

func draw_tile(tile):
	var c = colors[tile.type]
	var x = floor(lerp(0, width, (tile.position.x + 320) / 640))
	var y = floor(lerp(0, height, (tile.position.y + 180) / 360))
	img.set_pixel(x, y, c)
	img.set_pixel(x - 1, y, c)
	img.set_pixel(x, y - 1, c)
	img.set_pixel(x - 1, y - 1, c)

func draw_camera(camera):	
	var rect = camera.get_screen_rect()
	var x_min = int(lerp(0, width, rect.position.x/640))
	var x_max = int(lerp(0, width, rect.end.x/640)) - 1
	var y_min = int(lerp(0, height, rect.position.y/360))
	var y_max = int(lerp(0, height, rect.end.y/360)) - 1
	for x in range(x_min, x_max):
		img.set_pixel(x, y_min, Color(1, 1, 1))
		img.set_pixel(x, y_max, Color(1, 1, 1))
	for y in range(y_min, y_max):
		img.set_pixel(x_min, y, Color(1, 1, 1))
		img.set_pixel(x_max, y, Color(1, 1, 1))