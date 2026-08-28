class_name Trainer

var name: String
var monsters: Array[Monster] = []
var current_monster_index: int
var is_player: bool
var items: Array[Item] = []

var chosen_action_type: GameRunner.INTERACTION_MODE
var chosen_action_index: int = -1

var current_monster: Monster:
	get: return monsters[current_monster_index]

static func from_world_state(world_state: WorldState) -> Trainer:
	var trainer = Trainer.new()
	trainer.name = world_state.player_name
	trainer.monsters = world_state.monsters
	trainer.items = world_state.items
	trainer.is_player = true
	trainer.current_monster_index = world_state.current_monster_index
	return trainer
