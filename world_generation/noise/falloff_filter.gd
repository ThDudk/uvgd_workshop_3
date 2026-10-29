class_name FalloffFilter extends NoiseFilter

@export
var distance: float
@export 
var center: Vector2i
@export
var curve: Curve

func filter_pos(value: float, x: int, y: int) -> float:
	var rel_to_center = Vector2i(x, y) - center
	var dist_percent = value * (1 - rel_to_center.length() / distance)
	
	if curve != null:
		dist_percent = curve.sample(dist_percent)
		
	return dist_percent
