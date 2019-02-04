extends Node

signal player_turn_start()
signal player_turn_end()
signal ai_turn_start()

var player_turn = false
var ai_turn = false

func start_player_turn():
	player_turn = true
	emit_signal("player_turn_start")
	print("Player turn start")

func end_player_turn():
	player_turn = false
	ai_turn = true
	emit_signal("player_turn_end")
	print("Player turn end")
	emit_signal("ai_turn_start")
	print("AI turn start")

func on_ai_end_turn():
	ai_turn = false
	print("AI turn end")
	start_player_turn()

func _input(event):
	if player_turn:
		if event.is_action_pressed("end_turn"):
			end_player_turn()