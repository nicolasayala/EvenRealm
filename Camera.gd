extends Camera2D

signal moved()
signal zoomed()

const ZOOM_LEVELS = [1.5, 1.0, 0.5, 0.25]

export (Vector2) var speed = 5
export (Vector2) var bounds = Vector2(640, 360)

var _velocity = Vector2(0, 0)
var _current_zoom_index = 1
var _drag = false

func _process(delta):
	if (_velocity.length() > 0):
		var offset = get_offset() + _velocity.normalized() * speed
		set_offset(offset)
		_clamp_offset()

func _input(event):
	if event.is_action_pressed("cam_drag"):
		_drag = true
	elif event.is_action_released("cam_drag"):
		_drag = false
	elif event.is_action_pressed("cam_zoom_in"):
		_update_zoom(1, get_local_mouse_position())
	elif event.is_action_pressed("cam_zoom_out"):
		_update_zoom(-1, get_local_mouse_position())
	elif event is InputEventMouseMotion && _drag:
		set_offset(get_offset() - event.relative * ZOOM_LEVELS[_current_zoom_index])
		_clamp_offset()
		emit_signal("moved")

func _unhandled_input(event):
	if event.is_action_pressed("ui_right"):
		_velocity.x = 1
	if event.is_action_pressed("ui_left"):
		_velocity.x = -1
	if event.is_action_released("ui_right") or event.is_action_released("ui_left"):
		_velocity.x = 0
		
	if event.is_action_pressed("ui_up"):
		_velocity.y = -1
	if event.is_action_pressed("ui_down"):
		_velocity.y = 1
	if event.is_action_released("ui_up") or event.is_action_released("ui_down"):
		_velocity.y = 0

func _update_zoom(zoom_level_incr, zoom_anchor):
	var old_zoom_index = _current_zoom_index
	_current_zoom_index = clamp(_current_zoom_index + zoom_level_incr, 0, ZOOM_LEVELS.size() - 1)
	if old_zoom_index == _current_zoom_index:
		return
	var zoom_center = zoom_anchor - get_offset()
	var old_zoom = ZOOM_LEVELS[old_zoom_index]
	var current_zoom = ZOOM_LEVELS[_current_zoom_index]
	var ratio = 1 - (current_zoom / old_zoom)
	set_offset(get_offset() + zoom_center * ratio) 
	set_zoom(Vector2(current_zoom, current_zoom))
	_clamp_offset()
	emit_signal("zoomed")

func _clamp_offset():
	var zoom = ZOOM_LEVELS[_current_zoom_index]
	var camera_size = bounds * zoom
	var new_bounds = bounds
	if (zoom > 1):
		new_bounds *= zoom
	var offset = get_offset()
	var w = (new_bounds.x - camera_size.x) / 2
	var h = (new_bounds.y - camera_size.y) / 2
	offset.x = clamp(offset.x, - w, w)
	offset.y = clamp(offset.y, - h, h)
	set_offset(offset)

func get_screen_rect():
	var zoom = ZOOM_LEVELS[_current_zoom_index]
	var camera_size = bounds * zoom
	return Rect2(
		offset - camera_size * 0.5 + Vector2(320, 180),
		camera_size
	)