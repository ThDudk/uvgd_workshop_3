@tool
class_name SmallCactusAPI extends Node2D

enum Type {Green, Brown}
enum State {Plain, Flowering}

@export var type := Type.Green :
	set(value):
		type = value
		mutated.emit(self)

@export var state := State.Plain :
	set(value):
		state = value
		mutated.emit(self)

signal mutated(info: SmallCactusAPI)

func _ready() -> void:
	mutated.emit(self)
