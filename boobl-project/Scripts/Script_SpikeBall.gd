extends StaticBody2D


var realRotation

@onready var animated_sprite = $AnimatedSprite2D
@onready var player = $"../../../Player"


func _process(_delta: float) -> void:
	
	if player.velocity.length() > 0: # Just an optimization.
		_handle_rotation()
		_handle_animations()

func _handle_rotation():
	
	look_at(player.global_position)
	
	realRotation = rotation_degrees
	rotation = snappedf(rotation, deg_to_rad(90))

func _handle_animations():
	if (rotation_degrees - realRotation) > 15:
		animated_sprite.play("Diagonal_Up")
	elif (rotation_degrees - realRotation) < -15:
		animated_sprite.play("Diagonal_Down")
	else:
		animated_sprite.play("Straight")
