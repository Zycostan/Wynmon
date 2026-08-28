class_name WorldState
extends Node

var player_name: String
var monsters: Array[Monster] = []
var items: Array[Item] = []
var badges: Array[String] = []
var current_monster_index: int = 0

var current_monster: Monster:
	get: return monsters[current_monster_index]
