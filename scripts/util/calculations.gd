class_name Calculations

static func get_crit_chance(monster: Monster) -> float:
	return clamp(monster.speed / 100, 0.01, 0.5)

static func calculate_monster_stat(base: int, growth: float, level: int, condition_bonus: int):
	return clamp(base + (level * growth * base / 10.0) + condition_bonus, 1, 250)
