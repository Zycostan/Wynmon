class_name Calculations

const STAB_COEFFICIENT: float = 1.5

static func get_stab_coefficient(doer_type: MonsterType.Type, move_type: MonsterType.Type) -> float:
	return STAB_COEFFICIENT if doer_type == move_type else 1.0

static func get_crit_chance(monster: Monster) -> float:
	return clamp(monster.speed / 100, 0.01, 0.5)

static func calculate_monster_stat(base: int, growth: float, level: int, condition_bonus: int):
	return clamp(base + (level * growth * base / 10.0) + condition_bonus, 1, 250)

static func experience_for_level(level: int):
	return 200 * level

static func experience_value_of_monster(monster: Monster):
	return 600 * monster.level

static func get_catch_chance(monster: Monster, whistle_catch_modifier: float) -> float:
	var hp_ratio = float(monster.hp) / float(monster.max_hp)
	var low_hp_bonus = 1.0 - (hp_ratio * 0.75)
	var chance = monster.species.catch_rate * whistle_catch_modifier * low_hp_bonus
	return clamp(chance, 0.02, 0.95)
