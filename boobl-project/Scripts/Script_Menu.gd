extends CanvasLayer

var sonido = 2
var musica = 2
@onready var buttonContinue = $Continue
@onready var buttonSound = $Sound
@onready var buttonMusic = $Music
@onready var SfxSelect = $sfx_Select
@onready var SfxMusic = $sfx_Music
@onready var camera = get_node("../Scene_Gameplay/Camera2D")

func _ready() -> void:
	pause()

func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("gameplay_pause"):
		if get_tree().paused == false:
			pause()
			SfxSelect.playing = true
		elif get_tree().paused == true:
			resume()
	
	SfxSelect.position = camera.position
	SfxMusic.position = camera.position

func resume():
	get_tree().paused = false
	hide()

func pause():
	get_tree().paused = true
	buttonContinue.grab_focus()
	show()

func _on_continue_pressed() -> void:
	resume()
	SfxSelect.playing = true
func _on_continue_mouse_entered() -> void:
	buttonContinue.grab_focus()

func _on_sound_pressed() -> void:
	if sonido == 2:
		sonido = 0
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Sound"), true)
		buttonSound.icon = load("res://Sprites/UI/Sound_0.png")
	elif sonido == 0:
		sonido = 1
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound"), -6)
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Sound"), false)
		buttonSound.icon = load("res://Sprites/UI/Sound_1.png")
	elif sonido == 1:
		sonido = 2
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound"), 0)
		buttonSound.icon = load("res://Sprites/UI/Sound_2.png")
	SfxSelect.playing = true
func _on_sound_mouse_entered() -> void:
	buttonSound.grab_focus()

func _on_music_pressed() -> void:
	if musica == 2:
		musica = 0
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true)
		buttonMusic.icon = load("res://Sprites/UI/Music_0.png")
	elif musica == 0:
		musica = 1
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), -6)
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), false)
		buttonMusic.icon = load("res://Sprites/UI/Music_1.png")
	elif musica == 1:
		musica = 2
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), 0)
		buttonMusic.icon = load("res://Sprites/UI/Music_2.png")
	SfxSelect.playing = true
func _on_music_mouse_entered() -> void:
	buttonMusic.grab_focus()
