@tool
class_name LargeCactusAPI extends Node2D

enum Type {Green, Brown}
enum State {Plain, Flowering}

@export var type: Type = Type.Green :
	set(value):
		type = value
		mutated.emit(self)

@export var state: State = State.Plain : 
	set(value):
		state = value
		mutated.emit(self)

signal mutated(api: LargeCactusAPI)

func _ready() -> void:
	mutated.emit(self)
