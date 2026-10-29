@tool
class_name PineTreeAPI extends Node2D

enum LeafColor {Green, Pink, Red, Orange}
enum TrunkColor {Brown, Gray}
enum State {Normal, Snowy, CutDown}

@export var leaf_color := LeafColor.Green :
	set(value):
		leaf_color = value
		mutated.emit(self)

@export var trunk_color := TrunkColor.Brown :
	set(value):
		trunk_color = value
		mutated.emit(self)

@export var state := State.Normal :
	set(value):
		state = value
		mutated.emit(self)

signal mutated(api: PineTreeAPI)

func _ready() -> void:
	mutated.emit(self)
