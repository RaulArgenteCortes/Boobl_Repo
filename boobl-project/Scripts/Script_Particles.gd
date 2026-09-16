extends CPUParticles2D


func _ready() -> void:
	if one_shot:
		await finished
		queue_free()
