class_name AVFXPlaySFX
extends AVFXResource

@export var clip: AudioStream

func _do(instance: AVFXInstance):
	Events.request_sfx.emit(instance, clip)
