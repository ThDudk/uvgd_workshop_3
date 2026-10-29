class_name ScatterFilter extends Resource

static func in_biome(ctx: GenerationContext, biomes: Biomes, biome: String) -> InBiomeFilter:
	var filter = InBiomeFilter.new()
	filter.global_to_local = ctx.ground_tilemap.transform.affine_inverse()
	filter.cell_size = ctx.tile_size()
	filter.biomes = biomes
	filter.biome = biome
	return filter

static func rect_in_biome(ctx: GenerationContext, biomes: Biomes, biome: String, size: Vector2) -> RectInBiomeFilter:
	var filter = RectInBiomeFilter.new()
	filter.global_to_local = ctx.ground_tilemap.transform.affine_inverse()
	filter.cell_size = ctx.tile_size()
	filter.biomes = biomes
	filter.biome = biome
	filter.size = size
	return filter

static func remove_random(ctx: GenerationContext, percent_to_remove: float) -> RemoveRandomFilter:
	var filter = RemoveRandomFilter.new()
	filter.removal_percentage = percent_to_remove
	filter.random = ctx.random
	return filter

static func remove_random_thread_safe(ctx: GenerationContext, percent_to_remove: float) -> RemoveRandomFilter:
	var filter = RemoveRandomFilter.new()
	filter.removal_percentage = percent_to_remove
	filter.random = RandomNumberGenerator.new()
	filter.random.seed = ctx.random.seed
	filter.random.state = ctx.random.state
	return filter

static func noise_range(ctx: GenerationContext, noise: FilteredNoise, min_value: float, max_value: float) -> NoiseRangeFilter:
	var filter = NoiseRangeFilter.new()
	filter.global_to_local = ctx.ground_tilemap.transform.affine_inverse()
	filter.cell_size = ctx.tile_size()
	filter.noise = noise
	filter.min_value = min_value
	filter.max_value = max_value
	return filter

static func rect_in_map(ctx: GenerationContext, size: Vector2) -> CustomScatterFilter:
	var real_world_size := ctx.real_world_size()
	
	return custom(func(point):
		var top_left = (point - size / 2.0)
		var bottom_right = (point + size / 2.0)
		
		if bottom_right.x > real_world_size.x or bottom_right.y > real_world_size.y:
			return false
		
		if top_left.x < 0 or top_left.y < 0:
			return false
		
		return true
	)

static func custom(f: Callable) -> CustomScatterFilter:
	var filter = CustomScatterFilter.new()
	filter.callable = f
	return filter
