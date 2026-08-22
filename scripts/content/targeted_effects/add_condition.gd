class_name AddCondition
extends TargetedEffect

@export var condition_resource: ConditionResource
@export var chance_to_apply: float = 0.5


func _do(doer: Monster, source: Object, game_state: GameState, is_critical: bool, logs: Array[String]):
	var target = doer if target_self else MonsterController.get_monster_opponent(doer)
	
	if GameRunner.rng.randf() > chance_to_apply:
		
		MonsterController.instantiate_condition_on_monster(target, condition_resource)
	
	return
