extends Node2D


var moveSpeed = 10
var isEnabled = true

@onready var animatedSprite = $AnimatedSprite2D
@onready var player = get_node("../Player")
@onready var followPoint = get_node("../Player/BubbleFollow")


func _ready() -> void:
	position = player.global_position

func _process(_delta: float) -> void:
	_handle_follow(_delta)
	_handle_animations()

func _handle_follow(_delta):
	
	if !isEnabled && (player.canDash && !player.isDying):
		isEnabled = true
		position = Vector2(player.global_position.x, player.global_position.y + 5)
	if isEnabled && !(player.canDash && !player.isDying):
		isEnabled = false
	
	position.x = move_toward(position.x, followPoint.global_position.x, moveSpeed * _delta * abs(position.x - followPoint.global_position.x))
	position.y = move_toward(position.y, followPoint.global_position.y, moveSpeed * _delta * abs(position.y - followPoint.global_position.y))


func _handle_animations():
	if isEnabled:
		animatedSprite.play("Enabled")
	else:
		animatedSprite.play("Empty")
