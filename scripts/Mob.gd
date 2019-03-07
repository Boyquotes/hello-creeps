extends RigidBody2D

# Globals
var mob_types = ["walk", "swim", "fly"]

# Properties
export (int) var min_speed
export (int) var max_speed

func _ready():
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]

func _on_Visibillity_screen_exited():
	queue_free()
