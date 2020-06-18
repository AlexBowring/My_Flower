extends Area2D

export(String, FILE, "*.tscn") var next_level

func _process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			get_tree().change_scene(next_level)