class_name ItemResource
extends Resource

@export var name: String ## item name
@export var use_effects: Array[TargetedEffect] ## effects of the item
@export var use_avfx: Array[AVFXResource] ## sfx, etc
@export var consumable: bool = true ## can you consume it? yes or no??
@export var use_message: String = "{user_name} used {item_name}"
