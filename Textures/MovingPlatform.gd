extends Node2D


export var move_to = Vector2.UP*16*20
export var speed = 13

var follow = Vector2.ZERO

onready var platform = $Platform
onready var tween = $Tween

func _ready():
	_init_tween()
	
func _init_tween():
	var duration = move_to.length() / float(speed * 16)
	tween.interpolate_property(self, "follow", Vector2.ZERO, move_to, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	tween.interpolate_property(self, "follow", move_to, Vector2.ZERO, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration)
	tween.start()

func _physics_process(delta):
	platform.position = platform.position.linear_interpolate(follow, 0.075)


func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		get_tree().reload_current_scene()
