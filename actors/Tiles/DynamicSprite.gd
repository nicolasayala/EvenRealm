tool
extends Sprite

export (int) var tile_id = 0 setget set_tile_id

export (int) var tilesheet_cols = 16
export (int) var tilesheet_rows = 4
export (Vector2) var tile_size = Vector2(12, 10)

func _ready():
	region_enabled = true

func set_tile_id(id):
	tile_id = id % (tilesheet_rows * tilesheet_cols)
	var x = (tile_id % tilesheet_cols) * tile_size.x
	var y = (tile_id / tilesheet_cols) * tile_size.y
	region_rect = Rect2(x, y, tile_size.x, tile_size.y)