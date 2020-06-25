extends KinematicBody2D

onready var right_ray = get_node("RightCast2D")
onready var left_ray = get_node("LeftCast2D")
const UP = Vector2(0,-1)
const GRAVITY = 20
const MAX_SPEED = 600
const JUMP_HEIGHT = -500
const SMALL_JUMP_HEIGHT = -150
const WALLJUMP_HEIGHT = -350
const WALLJUMP_HORZ = 450
const ACCELERATION = 150
const AIR_RESISTANCE = 7
const GLIDE_HACCELERATION = 30
const GLIDE_HMAX_SPEED = 300
var off_ground_time = 0
var motion = Vector2()
var glide = false
var left_wall_jump = false
var right_wall_jump = false
var wall_jump_time = 0
var right_wall_jump_cool_down_time = 0
var left_wall_jump_cool_down_time = 0

func _physics_process(delta):
	var friction = false
	off_ground_time += delta
	right_wall_jump_cool_down_time += delta
	left_wall_jump_cool_down_time += delta
	
	if glide == false:
		motion.y = min(motion.y + GRAVITY, 1000)
	else:
		motion.y = min(motion.y + GRAVITY - AIR_RESISTANCE, 130)
		
	if (right_wall_jump == true) or (left_wall_jump == true):
		wall_jump_time += delta
	else:
		wall_jump_time = 0
	
	if Input.is_action_pressed("ui_right"):
		if right_wall_jump==true && glide == false && wall_jump_time < 0.2:
			motion.x = motion.x
		elif right_wall_jump==true && glide == false && wall_jump_time < 0.5:
			motion.x = lerp(motion.x, 0, 0.08)
		else: 
			right_wall_jump=false
			if glide == false:
				motion.x = min(max(motion.x + ACCELERATION, -50), MAX_SPEED)
			else:
				motion.x = min(max(motion.x + GLIDE_HACCELERATION, -50), GLIDE_HMAX_SPEED)
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.play("Run")
	elif Input.is_action_pressed("ui_left"):
		if left_wall_jump==true && glide == false && wall_jump_time < 0.2:
			motion.x = motion.x 
		elif left_wall_jump==true && glide == false && wall_jump_time < 0.5:
			motion.x = lerp(motion.x, 0, 0.08)
		else:
			left_wall_jump = false
			if glide == false:
				motion.x = max(min(motion.x - ACCELERATION, 50), -MAX_SPEED)
			else:
				motion.x = max(min(motion.x - GLIDE_HACCELERATION, 50), -GLIDE_HMAX_SPEED)
			$AnimatedSprite.play("Run")
			$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.play("Idle")
		friction = true
	
	if is_on_floor():
		off_ground_time = 0
		left_wall_jump = false
		right_wall_jump = false
		glide = false
		if Input.is_action_just_pressed("ui_select"):
			motion.y = JUMP_HEIGHT
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.3)
		right_wall_jump_cool_down_time = 1.5
		left_wall_jump_cool_down_time = 1.5
		
		if Input.is_action_just_released("ui_right"):
			motion.x = min(motion.x, 80)
		if Input.is_action_just_released("ui_left"):
			motion.x = max(motion.x, -80)
	else:
		off_ground_time += delta
		if Input.is_action_just_pressed("ui_select"):
			if right_ray.is_colliding() && glide==false && right_wall_jump_cool_down_time > 1.4:
				right_wall_jump = true
				left_wall_jump = false
				$AnimatedSprite.flip_h = true
				motion.y = JUMP_HEIGHT
				motion.x = -WALLJUMP_HORZ
				right_wall_jump_cool_down_time = 0
				left_wall_jump_cool_down_time = 1.5
				wall_jump_time = 0
			elif left_ray.is_colliding() && glide==false && left_wall_jump_cool_down_time > 1.4:
				$AnimatedSprite.flip_h = false
				left_wall_jump = true
				right_wall_jump = false
				motion.y = JUMP_HEIGHT
				motion.x = WALLJUMP_HORZ
				left_wall_jump_cool_down_time = 0
				right_wall_jump_cool_down_time = 1.5
				wall_jump_time = 0
			elif off_ground_time < 0.2:
				motion.y = JUMP_HEIGHT
			elif wall_jump_time == 0 or wall_jump_time > 0.2:
				glide = true
		
		if Input.is_action_just_released("ui_select") && motion.y < -150 && right_wall_jump == false && left_wall_jump == false && glide == false:
			motion.y = SMALL_JUMP_HEIGHT
		elif Input.is_action_just_released("ui_select") && glide == true:
			glide = false		
		
		if glide == false:
			if motion.y < 0:
				$AnimatedSprite.play("Jump")
			else:
				$AnimatedSprite.play("Fall")
		else:
			$AnimatedSprite.play("Glide")
		
		if Input.is_action_just_released("ui_right") && glide == false && right_wall_jump == false && left_wall_jump == false:
			motion.x = min(motion.x, 200)
		if Input.is_action_just_released("ui_left") && glide == false && right_wall_jump == false && left_wall_jump == false:
			motion.x = max(motion.x, -200)
		
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.04)
	
	motion = move_and_slide(motion, UP)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "LavaTiles":
			get_tree().reload_current_scene()
	pass
