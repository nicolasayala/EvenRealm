extends "res://actors/HexGrid/HexGridNode.gd"

signal selected
signal hover

enum TILE_TYPE {
	VOID,
	WATER,
	GRASS,
	SAND,
	ALIEN
}

export (TILE_TYPE) var type = VOID
var id = 0 setget set_id
var selected = false setget set_selected

func set_id(n):
	id = n
	$Sprite.set_tile_id(id)
	$Borders.set_tile_id(id)

func set_selected(s):
	selected = s
	$Borders.visible = selected

func _on_Area_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("tile_select"):
		emit_signal("selected")

func _on_Area_mouse_entered():
	emit_signal("hover")