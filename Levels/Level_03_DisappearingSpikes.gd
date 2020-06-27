extends Node

var timer = 0
var disappear = false
onready var DisappearingTiles = get_node("LavaTiles")
var DISAPPEARANCE_TIME = 1

func _physics_process(delta):
	timer += delta

	if timer > 0.4:
		self.remove_child(DisappearingTiles)

	if timer > DISAPPEARANCE_TIME + 0.8:
		self.add_child(DisappearingTiles)
		timer = 0
