extends Node

var game_state: GameState
var rng: RandomNumberGenerator

func _ready() -> void:
	Events.on_new_game_state_created.connect(get_controller_components)

func get_controller_components():
	game_state = GameRunner.game_state
	rng = GameRunner.rng

func get_monster_opponent(monster: Monster) -> Monster:
	if monster == game_state.player_monster:
		return game_state.opponent_monster
	
	if monster == game_state.opponent_monster:
		return game_state.player_monster
	
	return null

func get_current_monster() -> Monster:
	if game_state.is_player_turn:
		return game_state.player_monster
	else:
		return game_state.opponent_monster

func adjust_monster_hitpoints(monster: Monster, amount: int):
	monster.hp = clamp(monster.hp + amount, 0, monster.max_hp)
	
	if monster.hp == 0:
		faint_monster(monster)

func get_monster_move_at_index(monster: Monster, index: int) -> Move:
	if index == -1:
		return monster.fallback_move
	return monster.moves[index]

func use_monster_move(monster: Monster, move: Move):
	if move.usages <= 0 or monster.hp == 0:
		return
	
	var logs: Array[String] = []
	
	var use_string = move.use_message.format({"user_name": monster.name, "move_name": move.name})
	logs.append(use_string)
	
	var opponent = get_monster_opponent(monster)
	if opponent.hp == 0:
		monster.move_blocked = false
		return
	
	if monster.move_blocked:
		logs.append("They are paralyzed!")
		monster.move_blocked = false
		return
	
	move.usages -= 1
	
	var hit = rng.randf() < move.base_accuracy
	
	if !hit:
		logs.append("It missed!")
	
	var crit = rng.randf() < Calculations.get_crit_chance(monster)
	if crit:
		logs.append("Critical Hit!")
	
	for effect in move.resource.use_effects:
		if effect._should_do(hit, crit):
			effect._do(monster, move, game_state, crit, logs)
	
	var message_avfx = AVFXMessages.fromStrings(logs as Array[String])
	var avfx_group = move.resource.use_avfx.duplicate()
	avfx_group.append(message_avfx)
	AVFXManager.queue_avfx_effect_group(avfx_group, monster)
	
	var cleanup_avfx_group = []
	var update_effect: AVFXFunction = AVFXFunction.new(func(): Events.on_monster_updated.emit(monster))
	var target_effect: AVFXFunction = AVFXFunction.new(func(): Events.on_monster_updated.emit(opponent))
	AVFXManager.queue_avfx_effect_group([update_effect, target_effect], monster)

func faint_monster(monster: Monster):
	monster.conditions.clear()
	
	var flash = AVFXFlashMonster.new()
	flash.target_self = true
	flash.delay = 0.0
	
	var faint_message = AVFXMessages.fromStrings(["{monster_name} fainted!".format({"monster_name": monster.name})])
	
	await get_tree().create_timer(1.0).timeout
	AVFXManager.queue_avfx_effect_group([flash, faint_message], monster)
	

func create_monster(species: SpeciesResource, nickname: String = "") -> Monster:
	var monster = Monster.new()
	monster.species = species
	monster.hp = monster.max_hp
	monster.nickname = nickname
	
	# monster growth per level
	monster.hp_growth = rng.randf_range(0.4, 1.2)
	monster.atk_growth = rng.randf_range(0.4, 1.2)
	monster.def_growth = rng.randf_range(0.4, 1.2)
	monster.sp_atk_growth = rng.randf_range(0.4, 1.2)
	monster.sp_def_growth = rng.randf_range(0.4, 1.2)
	monster.speed_growth = rng.randf_range(0.4, 1.2)
	
	# moves
	var moves: Array[Move]
	
	for move_resource in species.starter_moves:
		if move_resource == null:
			continue
		var move = Move.new()
		move.resource = move_resource
		move.usages = move_resource.max_usages
		moves.append(move)
	
	monster.moves = moves
	
	monster.fallback_move = Move.new()
	monster.fallback_move.resource = load("res://content/moves/strg.tres")
	monster.fallback_move.usages = 999
	
	return monster

func add_experience_to_monster(monster: Monster, experience: int):
	monster.experience += experience
	while monster.experience >= Calculations.experience_for_level(monster.level):
		monster.experience -= Calculations.experience_for_level(monster.level)
		level_up_monster(monster)
	
	give_move_replace_choice(monster)

func level_up_monster(monster: Monster):
	monster.level += 1
	AVFXManager.queue_avfx_message("{monster_name} leveled up to {level}".format({"monster_name": monster.name, "level": monster.level}))
	
	var moves_to_learn = monster.species.learned_moves.filter(func(im): return im.integer == monster.level)
	
	for move_to_learn in moves_to_learn:
		monster.pending_moves_queue.append(move_to_learn.move)
	
	while monster.moves.size() < monster.MAX_MOVES:
		var move_to_add = monster.pending_moves_queue.pop_front()
		var move = Move.new()
		move.resource = move_to_add
		move.usages = move_to_add.max_usages
		monster.moves.append(move)
		
		AVFXManager.queue_avfx_message("{monster_name} has learned {move_name}".format({"monster_name": monster.name, "move_name": move.name}))

func give_move_replace_choice(monster: Monster):
	if monster.pending_moves_queue.size() == 0:
		return
	
	monster.pending_move = monster.pending_moves_queue.pop_front()
	if monster == game_state.player_monster:
		var labels: Array[StringEnabled] = []
		
		for move in monster.moves:
			labels.append(StringEnabled.new(move.name, true))
		
		var string = "{monster_name} wants to learn the move {move_name}. Replace a move?".format({"monster_name": monster.name, "move_name": monster.pending_move.name})
		var choice_yes = ChoiceResource.new("> Yes", func(): Events.on_player_pending_learn_move.emit(labels))
		var choice_no = ChoiceResource.new("> No", func(): AVFXManager.queue_avfx_message("Carry on then."))
		
		AVFXManager.queue_avfx_message(string, [choice_yes, choice_no])
	else:
		# handle opponent monster
		return

func set_monster_move_at_index_to_pending_move(monster: Monster, index: int):
	var previous_move = monster.moves[index]
	var move = Move.new()
	move.resource = monster.pending_move
	move.usages = move.resource.max_usages
	monster.moves[index] = move
	monster.pending_move = null
	
	Events.on_player_move_replace_completed.emit()
	
	AVFXManager.queue_avfx_message("{monster_name} forgot the move {old_move_name} and learned {new_move_name}".format({"monster_name": monster.name, "old_move_name": previous_move.name, "new_move_name": move.name}))
	
	give_move_replace_choice(monster)

func instantiate_condition_on_monster(monster: Monster, condition_resource: ConditionResource):
	if monster.conditions.filter(func(condition): return condition.resource == condition_resource).size() >= condition_resource.max_stacks:
		return
	
	var condition = Condition.new()
	condition.resource = condition_resource
	condition.duration_remaining = condition.resource.duration
	monster.conditions.append(condition)
	

func on_turn_begun(monster: Monster):
	if monster.hp == 0:
		return
	for condition in monster.conditions.duplicate():
		var logs: Array[String] = []
		AVFXManager.queue_avfx_effect_group(condition.resource.on_begin_turn_avfx, monster)
		for effect in condition.resource.on_begin_turn_effects:
			effect._do(monster, condition, game_state, false, logs)
		if logs.size() > 0:
			var message_avfx= AVFXMessages.fromStrings(logs)
			AVFXManager.queue_avfx_effect_group([message_avfx], monster)
		condition.duration_remaining -= 1
		if condition.duration_remaining <= 0:
			end_condition(monster, condition)

func end_condition(monster: Monster, condition: Condition):
	monster.conditions.remove_at(monster.conditions.find(condition))
