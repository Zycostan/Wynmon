class_name TargetedEffect
extends Resource

enum OutcomFilter {
	HIT,
	MISS,
	BOTH,
	CRIT
}

@export var outcome_filter: OutcomFilter
@export var target_self: bool

func _do(doer: Monster, source: Object, game_state: GameState, is_critical: bool):
	return

func _should_do(is_hit: bool, is_critical: bool) -> bool:
	return outcome_filter == OutcomFilter.BOTH or (is_hit and outcome_filter == OutcomFilter.HIT) or (!is_hit and outcome_filter == OutcomFilter.MISS) or (is_critical and outcome_filter == OutcomFilter.CRIT)
