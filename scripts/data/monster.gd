class_name Monster

var species: SpeciesResource
var hp: int
var nickname: String
var moves: Array[Move]
var conditions: Array[Condition]
var fallback_move

#cleared after each turn
var move_blocked
var chosen_move

var image: Texture2D:
	get: return species.image

var name: String:
	get: return nickname if nickname else species.name

var type: MonsterType.Type:
	get: return species.type

# stats
var max_hp: int:
	get: return clamp(species.base_max_hp + sum_condition_stats_for_code(Stat.Code.MAX_HP), 1, 250)

var attack: int:
	get: return clamp(species.base_attack + sum_condition_stats_for_code(Stat.Code.ATK), 1, 200)

var defense: int:
	get: return clamp(species.base_defense + sum_condition_stats_for_code(Stat.Code.DEF), 1, 220)

var speed: int:
	get: return clamp(species.base_speed + sum_condition_stats_for_code(Stat.Code.SPD), 1, 180)

var sp_def: int:
	get: return clamp(species.base_sp_defense + sum_condition_stats_for_code(Stat.Code.SP_DEF), 1, 220)

var sp_atk: int:
	get: return clamp(species.base_sp_attack + sum_condition_stats_for_code(Stat.Code.SP_ATK), 1, 200)

func get_legal_move_indices() -> Array[int]:
	var legal_indices: Array[int] = []
	for i in range(0, moves.size()):
		if moves[i] and moves[i].usages > 0:
			legal_indices.append(i)
	return legal_indices

func sum_condition_stats_for_code(code: Stat.Code):
	var sum = 0
	for condition in conditions:
		for stat_modifier in condition.resource.stat_modifiers:
			if stat_modifier.stat == code:
				sum += stat_modifier.modifier
	return sum

func get_condition_string():
	if conditions.size() == 0:
		return "LV1"
	else:
		return conditions[0].resource.short_name

func dump_state():
	var condition_string = ""
	
	for condition in conditions:
		condition_string += "{name} - ({remaining})\n".format({"name": condition.name, "remaining": condition.duration_remaining})

	
	return "Name: {name}\n HP: ({hp}/{max_hp})\n ATK: {attack}\n DEF: {defense}\n SPECIAL ATK: {sp_atk}\n SPECIAL DEF: {sp_def}\n SPEED: {speed}\n Conditions:\n {conditions}"\
	.format({
		"name": name,
		"attack": attack,
		"defense": defense,
		"speed": speed,
		"hp": hp,
		"max_hp": max_hp,
		"sp_atk": sp_atk,
		"sp_def": sp_def,
		"conditions": condition_string
	})
