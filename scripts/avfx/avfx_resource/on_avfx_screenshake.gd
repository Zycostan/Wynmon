class_name AVFXScreenShake
extends AVFXResource

@export var screen_offsets_and_timings: Array[Vector3]

func _do(instance: AVFXInstance):
	Events.on_avfx_screenshake.emit(instance, screen_offsets_and_timings)
