extends Node2D

# Referencia al AudioStreamPlayer
@onready var music_player = $Music/AudioStreamPlayer

func _ready():
	setup_background_music()
	connect_audio_signals()

func setup_background_music():
	if music_player and music_player.stream:
		music_player.autoplay = true
		music_player.bus = "Master"
		
		# Configurar loop según el tipo de archivo
		if music_player.stream is AudioStreamOggVorbis:
			music_player.stream.loop = true
		elif music_player.stream is AudioStreamMP3:
			music_player.stream.loop = true
		elif music_player.stream is AudioStreamWAV:
			music_player.stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
		
		if not music_player.playing:
			music_player.play()

func connect_audio_signals():
	if music_player and not music_player.finished.is_connected(_on_music_finished):
		music_player.finished.connect(_on_music_finished)

func _on_music_finished():
	music_player.play()

func _process(_delta):
	if music_player and music_player.stream and not music_player.playing:
		music_player.play()

# ==========================================
# VERSIÓN SIMPLE (alternativa más básica)
# ==========================================
# extends Node
# @onready var music_player = $music/AudioStreamPlayer
# 
# func _ready():
#     if music_player:
#         music_player.play()
# 
# func _process(_delta):
#     if music_player and not music_player.playing:
#         music_player.play()
