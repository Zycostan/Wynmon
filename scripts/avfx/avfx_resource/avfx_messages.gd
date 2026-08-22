class_name AVFXMessages
extends AVFXResource

@export var messages: Array[String]

func _init(msgs: Array[String]) -> void:
	messages = msgs

func _do(instance: AVFXInstance):
	Events.on_avfx_messages.emit(instance, messages)
