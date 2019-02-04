extends PanelContainer

export(bool) var unfold_on_load = false
var folded = true

func _ready():
	if unfold_on_load:
		change_state()

func _input(event):
	if event.is_action_pressed("hide_panel"):
		change_state()

func change_state():
	set_process_input(false)
	if (folded):
		$AnimationPlayer.play_backwards("fold")
	else:
		$AnimationPlayer.play("fold")
	folded = !folded
	yield($AnimationPlayer, "animation_finished")
	set_process_input(true)