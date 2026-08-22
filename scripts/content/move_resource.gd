class_name MoveResource
extends Resource

@export var name: String ## move name
@export var max_usages: int ## how many times you can use the move
@export var use_effects: Array[TargetedEffect] ## effects of the move
@export var type: MonsterType.Type ## attack type
@export var use_message: String = "{user_name} used {move_name}" ## "Wyvern used Attack Boost" smthing like that
@export var base_accuracy: float = 0.9 ## between 0 to 1
@export var move_priority: int ## move priority, a move that goes before another move
@export var use_avfx: Array[AVFXResource] ## sfx, etc
