extends KinematicBody2D

onready var down_ray = get_node("RayCast2D")
onready var down_ray2 = get_node("RayCast2D2")
var motion = Vector2()
var degrees = self.get_rotation()
var UP = Vector2(0,-1)
var spike_wait_timer = 0
var lift_off = false

func _physics_process(delta):
	if spike_wait_timer > 0:
		lift_off = true
		
	var radians = self.get_rotation()
		
	var body = down_ray.get_collider()
	var body2 = down_ray2.get_collider()
	if body != null:
		if body.get_class() == "KinematicBody2D":
			spike_wait_timer += delta
	if body2 != null:
		if body2.get_class() == "KinematicBody2D":
			spike_wait_timer += delta
	
	if spike_wait_timer > 0:
		motion.y = 350
		motion.x = 0
		motion = motion.rotated(radians)
		motion.x = int(round(motion.x))
		motion.y = int(round(motion.y))
		
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if collision.collider.name == "Player":
				get_tree().reload_current_scene()
			if lift_off ==  true and collision.collider.name == "GrassyTiles":
				queue_free()

	motion = move_and_slide(motion, UP)
