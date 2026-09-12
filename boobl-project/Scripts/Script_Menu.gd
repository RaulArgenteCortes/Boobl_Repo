extends CanvasLayer

func _ready() -> void:
	pause()

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
	$Continue.grab_focus()
	show()

func _on_continue_pressed() -> void:
	resume()
	print("c")
func _on_continue_mouse_entered() -> void:
	$Continue.grab_focus()

func _on_sound_pressed() -> void:
	print("s")
func _on_sound_mouse_entered() -> void:
	$Sound.grab_focus()

func _on_music_pressed() -> void:
	print("m")
func _on_music_mouse_entered() -> void:
	$Music.grab_focus()
