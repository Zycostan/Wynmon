class_name ChoiceResource
extends Resource

@export var text: String
@export var function: Callable

func _init(txt: String, fn: Callable) -> void:
	text = txt
	function = fn
