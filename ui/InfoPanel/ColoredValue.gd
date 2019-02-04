tool
extends Label

export (Color) var positive_color = Color(0, 1, 0)
export (Color) var neutral_color = Color(1, 1, 1)
export (Color) var negative_color = Color(1, 0, 0)
export (int) var value = 0 setget set_value

func set_value(v):
	value = v
	var color
	if (value == 0):
		color = neutral_color
		self.text = str(v)
	elif (value > 0):
		color = positive_color
		self.text = "+ " + str(v)
	else:
		color = negative_color
		self.text = "- " + str(abs(v))
	set("custom_colors/font_color", color)
