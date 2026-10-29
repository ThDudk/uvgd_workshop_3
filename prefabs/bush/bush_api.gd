@tool
class_name BushAPI extends Node2D

enum Type {Fall, Desert, Grasslands, Snow}
enum Shade {Light, Medium, Dark}

@export var type: Type = Type.Fall :
	set(value):
		type = value
		mutated.emit(self)

@export var shade: Shade = Shade.Light : 
	set(value):
		shade = value
		mutated.emit(self)

signal mutated(bush_api: BushAPI)

func _ready() -> void:
	mutated.emit(self)
