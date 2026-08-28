class_name SpeciesResource
extends Resource


@export var image: Texture2D
@export var name: String
@export var starter_moves: Array[MoveResource]
@export var type: MonsterType.Type

@export var base_max_hp: int
@export var base_attack: int
@export var base_defense: int
@export var base_speed: int
@export var base_sp_attack: int
@export var base_sp_defense: int

@export var learned_moves: Array[IntMoveResource]
@export_range(0.02, 1.0) var catch_rate: float = 0.2
