extends Area2D

@export var destroy_priority: int = 5

func _ready() -> void:
	connect("area_entered", _on_overlap_area_area_entered)

func _on_overlap_area_area_entered(area: Area2D) -> void:
	var other_destroy_priority = area.get("destroy_priority")
	if other_destroy_priority == null: return
	
	other_destroy_priority = int(other_destroy_priority)
	if other_destroy_priority >= self.destroy_priority:
		get_parent().queue_free()
