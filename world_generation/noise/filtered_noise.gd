class_name FilteredNoise extends Resource

@export
var noise: FastNoiseLite = FastNoiseLite.new()
@export
var filters: Array[NoiseFilter] = []


func set_seed(world_seed: int):
	if noise != null:
		self.noise.seed = world_seed
	else:
		push_error("No noise function provided. Ensure you use provide_noise(...), before calling set_seed(...)")

func value_at(x: int, y: int) -> float:
	if noise == null:
		push_error("No noise function provided. Ensure you use provide_noise(...), before calling value_at(...)")
		return 0
	
	var running_value: float = noise.get_noise_2d(x, y)
	
	for filter in filters:
		if filter.has_method("filter"):
			running_value = filter.filter(running_value)
			
		if filter.has_method("filter_pos"):
			running_value = filter.filter_pos(running_value, x, y)
	
	return running_value

static func build(_noise: FastNoiseLite, _filters: Array[NoiseFilter]):
	var filtered_noise = FilteredNoise.new()
	filtered_noise.noise = _noise
	filtered_noise.filters = _filters
	return filtered_noise
