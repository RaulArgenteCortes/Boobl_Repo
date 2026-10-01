extends Area2D


@onready var animated_sprite = $AnimatedSprite2D
@onready var spawnPlayer = $"../../../SpawnPlayer"
@onready var SfxSpawnPoint = $sfx_SpawnPoint


func _process(_delta: float) -> void:
	_handle_animations()


func _handle_animations():
	if spawnPlayer.position == position:
		animated_sprite.play("Idle_On")
	else:
		animated_sprite.play("Idle_Off")


func _on_body_entered(_body: Node2D) -> void:
	if (spawnPlayer.position != position):
		spawnPlayer.position = position
		SfxSpawnPoint.playing = true
