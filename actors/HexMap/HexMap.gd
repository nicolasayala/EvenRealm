extends Node2D

export (PackedScene) var VoidTile
export (PackedScene) var GrassTile
export (PackedScene) var WaterTile
export (PackedScene) var AlienTile

var selected_region = Array()

func _ready():
	spawn_tiles()

func spawn_tiles():
	for hex in Hex.rect(Vector3(0, 0, 0), 50, 48): ##fullscreen 50/48
		var r = randf()
		var node
		if (r > 0.975):
			node = AlienTile
		elif (r > 0.70):
			node = GrassTile
		else:
			node = WaterTile
		$HexGrid.add_node(hex, node)
	$HexGrid.update_nodes()

func _on_HexGrid_node_hovered(node):
	$HexGrid/Selector.position = node.position

func _on_HexGrid_node_selected(node):
	for node in selected_region:
		node.set_selected(false)
	
	if (node.type == node.TILE_TYPE.WATER):
		return
	selected_region = $HexGrid.flood_fill(node)
	for other in selected_region:
		other.set_selected(true)

