extends Node

var timer = 0
var disappear = false
onready var DisappearingTiles = get_node("LavaTiles")

func _physics_process(delta):
	timer += delta

	if timer > 0.4:
		self.remove_child(DisappearingTiles)

	if timer > 1.0:
		self.add_child(DisappearingTiles)
		timer = 0
