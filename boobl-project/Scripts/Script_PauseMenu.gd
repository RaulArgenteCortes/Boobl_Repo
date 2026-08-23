extends Control


func _ready() -> void:
	hide()

func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("gameplay_pause"):
		if get_tree().paused == false:
			pause()
		elif get_tree().paused == true:
			resume()

func resume():
	get_tree().paused = false
	hide()

func pause():
	get_tree().paused = true
	show()


func _on_resume_button_up() -> void:
	resume()
	print("1")

func _on_options_button_up() -> void:
	print("2")

func _on_quit_button_up() -> void:
	print("3")
