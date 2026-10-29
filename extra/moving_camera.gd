extends Camera2D

@export var speed: float = 500
@export var zoom_speed: float = 1

const FAST_SPEED_MULTIPLIER := 5
const FAST_ZOOM_SPEED_MULTIPLIER := 3

func _process(delta: float) -> void:
	var dir = Input.get_vector("left", "right", "up", "down")
	if Input.is_action_pressed("speed"):
		position += dir * speed * FAST_SPEED_MULTIPLIER * delta
	else:
		position += dir * speed * delta
	
	var zoom_amt: float = Input.get_axis("zoom_out", "zoom_in")
	var new_zoom = zoom.x + zoom_amt * zoom_speed * delta
	if Input.is_action_pressed("speed"):
		new_zoom = zoom.x + zoom_amt * zoom_speed * delta * FAST_ZOOM_SPEED_MULTIPLIER
		
	zoom = Vector2.ONE * max(0.01, new_zoom)
