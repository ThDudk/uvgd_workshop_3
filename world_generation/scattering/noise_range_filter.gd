class_name NoiseRangeFilter extends ScatterFilter

var global_to_local: Transform2D
var cell_size: Vector2
var noise: FilteredNoise
var min_value: float
var max_value: float

func filter(array: Array) -> Array:
	return array.filter(func(point):
		var local_pos = global_to_local * point
		var tile = Vector2i(
			floori(local_pos.x / cell_size.x), 
			floori(local_pos.y / cell_size.y)
		);
		
		var value = noise.value_at(tile.x, tile.y)
		return value >= min_value and value <= max_value
	);
