extends Node2D

func set_camera_limits():
	var map_limits = $Border.get_used_rect()
	var map_cellsize = $Border.cell_size
	$Player/Camera2D.limit_left = (map_limits.position.x+1) * map_cellsize.x
	$Player/Camera2D.limit_right = (map_limits.end.x-1) * map_cellsize.x
	$Player/Camera2D.limit_top = (map_limits.position.y+1) * map_cellsize.y
	$Player/Camera2D.limit_bottom = (map_limits.end.y-1) * map_cellsize.y

onready var ray = get_node("RayCast2D")

func _physics_process(delta):
	var colliding = ray.get_collider()
	if colliding != null:
		$Player.left_wall_jump_cool_down_time = 1.5

# Called when the node enters the scene tree for the first time.
func _ready():
	set_camera_limits()

