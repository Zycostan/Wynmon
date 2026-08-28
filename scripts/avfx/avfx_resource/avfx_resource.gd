class_name AVFXResource
extends Resource

@export var target_self: bool
@export var delay: float

func _do(instance: AVFXInstance):
	return

func generate(target: Monster, user: Monster):
	var resolved_target = user if target_self else target
	return AVFXInstance.new(self, resolved_target, user)
