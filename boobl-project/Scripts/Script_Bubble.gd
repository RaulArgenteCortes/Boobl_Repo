extends Area2D


@onready var animated_sprite = $AnimatedSprite2D
@onready var player = $"../../../Player"
@onready var bubblePlayer = $"../../../BubblePlayer"


func _process(_delta: float) -> void:
	if player.onGround || player.animated_sprite.animation == "Death":
		animated_sprite.play("Enabled")

func _on_body_entered(_body: Node2D) -> void:
	if player.canDash == false && animated_sprite.animation == "Enabled":
		player.canDash = true
		bubblePlayer.position = position
		animated_sprite.play("Disabled")
