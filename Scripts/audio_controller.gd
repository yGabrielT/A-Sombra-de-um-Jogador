class_name  AudioController
extends Node2D

var master_bus := AudioServer.get_bus_index("Master")
var sfx_bus := AudioServer.get_bus_index("SFX")
var music_bus := AudioServer.get_bus_index("Music")
var ambient_bus := AudioServer.get_bus_index("Ambient")

func _enter_tree() -> void:
	Global.audio_controller = self

func play_sound_with_pitch(stream : AudioStream, pitch : float = 1.0, volume : float = 1.0) -> void:
	var sound_instance = AudioStreamPlayer.new()
	self.add_child(sound_instance)
	sound_instance.bus = "SFX"
	sound_instance.stream = stream
	sound_instance.volume_linear = volume
	sound_instance.pitch_scale = pitch
	sound_instance.play()

func play_sounds_with_pitch(stream : Array[AudioStream], pitch : float = 1.0, volume : float = 1.0) -> void:
	var sound_instance = AudioStreamPlayer.new()
	self.add_child(sound_instance)
	var i = (randi_range(1,stream.size())) - 1
	sound_instance.bus = "SFX"
	sound_instance.stream = stream[i]
	sound_instance.volume_linear = volume
	sound_instance.pitch_scale = pitch
	sound_instance.play()
	sound_instance.connect("finished", func(): sound_instance.queue_free())

func play_ambient_sound(stream : AudioStream, volume : float = 1.0) -> void:
	var sound_instance = AudioStreamPlayer.new()
	self.add_child(sound_instance)
	sound_instance.bus = "Ambient"
	sound_instance.stream = stream
	sound_instance.volume_linear = volume
	sound_instance.play()

func change_bus_volume(bus_idx : int, volume : float):
	AudioServer.set_bus_volume_linear(bus_idx, volume)
