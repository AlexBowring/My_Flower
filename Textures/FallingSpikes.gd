extends KinematicBody2D
onready var down_ray = get_node("RayCast2D")
var motion = Vector2()
const UP = Vector2(0,-1)
var spike_wait_timer = 0
var lift_off = false

func _physics_process(delta):
	if motion.y > 0:
		lift_off = true
	
	var body = down_ray.get_collider()
	if body.get_class() == "KinematicBody2D":
		spike_wait_timer += delta
	
	if spike_wait_timer > 0:
		motion.y = 600
		
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if collision.collider.name == "Player":
				get_tree().reload_current_scene()
			if lift_off ==  true and collision.collider.name == "GrassyTiles":
				queue_free()
		
	motion = move_and_slide(motion, UP)
