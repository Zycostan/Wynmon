class_name MessageResource
extends Resource

@export var text: String
@export var choices: Array[ChoiceResource]

func _init(txt: String, chc: Array[ChoiceResource] = []) -> void:
	text = txt
	choices = chc
