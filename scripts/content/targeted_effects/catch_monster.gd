class_name CatchMonster
extends TargetedEffect

@export var whistle_catch_modifier: float = 1.0
@export var blocked_by_trainer_log_string: String = "{trainer_name} blocked the soothing whistle"
@export var catch_log_string: String = "{target_name} was subdued by the soothing whistle"
@export var escape_log_string: String = "{target_name} resisted the whistle"

func _do(doer: Monster, source: Object, game_state: GameState, is_critical: bool, logs: Array[String]):
	var catcher_trainer = game_state.player if doer == game_state.player_monster else game_state.opponent
	var target_trainer = game_state.opponent if catcher_trainer == game_state.player else game_state.player
	var target = target_trainer.current_monster
	
	if not target_trainer.is_wild_encounter:
		logs.append(blocked_by_trainer_log_string.format({"trainer_name": target_trainer.name}))
		return
	
	var chance = Calculations.get_catch_chance(target, whistle_catch_modifier)
	var success = GameRunner.rng.randf() < chance
	
	if success:
		target.was_caught = true
		logs.append(catch_log_string.format({"target_name": target.name}))
	else:
		target.was_caught = false
		logs.append(escape_log_string.format({"target_name": target.name}))
