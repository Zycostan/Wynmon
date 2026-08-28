class_name Trainer

var name: String
var monsters: Array[Monster] = []
var current_monster_index: int
var is_player: bool
var items: Array[Item] = []

var chosen_action_type: GameRunner.INTERACTION_MODE
var chosen_action_index: int = -1

var is_wild_encounter: bool = false

var current_monster: Monster:
	get: return monsters[current_monster_index]
