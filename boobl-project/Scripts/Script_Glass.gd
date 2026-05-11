extends Area2D


var canClose = true

@onready var static_body = $StaticBody2D/CollisionShape2D
@onready var animated_sprite = $AnimatedSprite2D
@onready var player = $"../../../Player"


func _process(_delta: float) -> void:
	
	if player.isDashing:
		static_body.set_deferred("disabled", true)
	elif canClose:
		static_body.set_deferred("disabled", false)

func _on_body_entered(_body: Node2D) -> void:
	canClose = false
	animated_sprite.play("Open")

func _on_body_exited(_body: Node2D) -> void:
	canClose = true
	animated_sprite.play("Close")

func _on_animation_finished() -> void:
	if animated_sprite.animation == "Close":
		animated_sprite.play("Idle")
