extends Area2D

var transformed = false

@onready var animated_sprite = $AnimatedSprite2D


func _process(_delta: float) -> void:
	if transformed:
		position.x = move_toward(position.x, 0, 2 * _delta * abs(position.x - 0))
		position.y = move_toward(position.y, 0, 2 * _delta * abs(position.y - 0))

func _on_body_entered(_body: Node2D) -> void:
	animated_sprite.play("Completed")
	_body.canDash = false
	transformed = true
	_body.visible = false
	_body.process_mode = Node.PROCESS_MODE_DISABLED
	await get_tree().create_timer(7).timeout
	get_tree().quit()
