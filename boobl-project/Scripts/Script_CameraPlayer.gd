extends Camera2D


@onready var player = get_node("../Player")
@onready var bigBubble = get_node("../BigBubble")


func _process(_delta: float) -> void:
	# This creates the feeling that the entire map is divided into "rooms".
	if player.visible == true:
		position = snapped(player.position, Vector2(256, 144))
	else:
		position = snapped(bigBubble.position, Vector2(256, 144))
