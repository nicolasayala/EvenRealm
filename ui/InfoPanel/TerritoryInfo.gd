extends PanelContainer

onready var savings = $MarginContainer/VBoxContainer/Savings/Value
onready var income = $MarginContainer/VBoxContainer/Income/Value
onready var wages = $MarginContainer/VBoxContainer/Wages/Value
onready var balance = $MarginContainer/VBoxContainer/Balance/Value
onready var money = $MarginContainer/VBoxContainer/Money/Value

func set_values(territory):
	var s = 0
	var i = territory.size()
	var w = 0
	savings.set_value(s)
	income.set_value(i)
	wages.set_value(w)
	balance.set_value(s + i + w)
	money.set_value(s + i + w)
