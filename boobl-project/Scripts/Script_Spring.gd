extends Area2D


var bounceForce = -155

@onready var animated_sprite = $AnimatedSprite2D
@onready var spawnPlayer = $"../../../SpawnPlayer"


func _on_body_entered(_body: Node2D) -> void:
	_body.velocity.y = bounceForce
	_body.isDashing = false
	animated_sprite.play("Bounce")

func _on_body_exited(_body: Node2D) -> void:
	# This makes that the height of the bounce is fixed.
	_body.velocity.y = bounceForce
	_body.isDashing = false

func _on_animation_finished() -> void:
	if animated_sprite.animation == "Bounce":
		animated_sprite.play("Idle")
