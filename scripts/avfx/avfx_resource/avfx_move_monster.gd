class_name AVFXMoveMonster
extends AVFXResource

@export var offset_by_duration: Array[Vector2Float]

func _do(instance: AVFXInstance):
	Events.on_avfx_move.emit(instance, offset_by_duration)
