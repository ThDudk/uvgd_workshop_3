@tool
class_name MushroomAPI extends Node2D

enum Type {Red, Turquoise, Green, Pink, Brown}
enum Size {Large, Medium, Small}

@export var type := Type.Red :
	set(value):
		type = value
		mutated.emit(self)

@export var size := Size.Small :
	set(value):
		size = value
		mutated.emit(self)

signal mutated(api: MushroomAPI)

func _ready() -> void:
	mutated.emit(self)
