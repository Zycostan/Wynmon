class_name MonsterType

enum Type {
	NORMAL,
	EARTH,
	FIRE,
	WATER,
	ELECTRIC,
	LIGHT,
	DARK
}

enum Effectiveness {
	NEUTRAL,
	WEAK,
	STRONG
}

const DAMAGE_MODIFIER_BY_EFFECT: Dictionary[Effectiveness, float] = {
	Effectiveness.NEUTRAL: 1.0,
	Effectiveness.WEAK: 0.5,
	Effectiveness.STRONG: 2.0
}

const EFFECTIVENESS_BY_TYPE: Dictionary[Type, Dictionary] = {
	Type.NORMAL: {},
	Type.EARTH: {
		Type.FIRE: Effectiveness.WEAK,
		Type.WATER: Effectiveness.STRONG
	},
	Type.FIRE: {
		Type.WATER: Effectiveness.WEAK,
		Type.EARTH: Effectiveness.STRONG
	},
	Type.WATER: {
		Type.EARTH: Effectiveness.WEAK,
		Type.FIRE: Effectiveness.STRONG
	},
	Type.ELECTRIC: {
		Type.EARTH: Effectiveness.STRONG,
		Type.FIRE: Effectiveness.WEAK
	},
	Type.LIGHT: {
		Type.DARK: Effectiveness.STRONG
	},
	Type.DARK: {
		Type.LIGHT: Effectiveness.STRONG
	}
}

static func get_type_effectiveness(source_type: Type, target_type: Type):
	if !EFFECTIVENESS_BY_TYPE.has(source_type) or !EFFECTIVENESS_BY_TYPE[source_type].has(target_type):
		return Effectiveness.NEUTRAL
	return EFFECTIVENESS_BY_TYPE[source_type][target_type]

static func get_typing_advantage_coefficient(source_type: Type, target_type: Type):
	var effectiveness = get_type_effectiveness(source_type, target_type)
	return DAMAGE_MODIFIER_BY_EFFECT[effectiveness]
