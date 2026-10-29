class_name NoiseFilter extends Resource

## Takes a callable with the signature f(value: float) -> float
static func custom(f: Callable) -> CustomNoiseFilter:
	var filter = CustomNoiseFilter.new()
	filter.f = f
	
	return filter

## Takes a callable with the signature f(value: float, x: int, y: int) -> float
static func custom_positional(f: Callable) -> CustomPositionalNoiseFilter:
	var filter = CustomPositionalNoiseFilter.new()
	filter.f = f
	
	return filter

static func map(old_min: float, old_max: float, new_min: float, new_max: float) -> MapFilter:
	var filter = MapFilter.new()
	filter.old_min = old_min
	filter.old_max = old_max
	filter.new_min = new_min
	filter.new_max = new_max
	
	return filter

static func clamp_value(_min: float, _max: float) -> CustomNoiseFilter:
	return NoiseFilter.custom(func(value):
		if value < _min: return _min
		elif value > _max: return _max
		else: return value
	);

static func remap_range(range_min: float, range_max: float, new_min: float, new_max: float) -> RemapRangeFilter:
	var filter = RemapRangeFilter.new()
	filter.range_min = range_min
	filter.range_max = range_max
	filter.new_min = new_min
	filter.new_max = new_max
	
	return filter

static func remap_range_with_curve(range_min: float, range_max: float, curve: Curve) -> RemapRangeWithCurveFilter:
	var filter = RemapRangeWithCurveFilter.new()
	filter.range_min = range_min
	filter.range_max = range_max
	filter.curve = curve.duplicate(true) # Just to be safe lol — Hate godot threads.
	
	return filter

static func falloff(distance: float, center: Vector2i) -> FalloffFilter:
	var filter = FalloffFilter.new()
	filter.distance = distance
	filter.center = center
	
	return filter

static func falloff_with_curve(distance: float, center: Vector2i, curve: Curve) -> FalloffFilter:
	var filter = FalloffFilter.new()
	filter.distance = distance
	filter.center = center
	filter.curve = curve.duplicate(true) # Just to be safe lol — Hate godot threads.
	
	return filter
