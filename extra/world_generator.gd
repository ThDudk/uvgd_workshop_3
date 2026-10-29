class_name WorldGenerator extends Node

@export_category("Noise Layers")
@export var raw_height: FastNoiseLite

@onready # This needs @onready since raw_height is a editor value, so it's only available on `_ready()`
var height = FilteredNoise.build(raw_height, [
	NoiseFilter.map(-1, 1, 0, 1),
	NoiseFilter.falloff(64, Vector2i(64, 64)),
	NoiseFilter.clamp_value(0, 1),
	NoiseFilter.remap_range(0, 0.3, -1, 0.3),
])

@onready # @onready needed since `height` is @onready
var biomes: Biomes = Biomes.build([
	Biome.build("Ocean", BiomeCondition.noise_less_than(height, -0.1)),
	Biome.build("Beach", BiomeCondition.noise_less_than(height, 0.1)),
	Biome.default("Grass"),
])

func generate(ctx: GenerationContext):
	height.set_seed(ctx.world_seed)
	
	await place_floor_tiles(ctx)
	await spawn_trees_naive(ctx)
	#await spawn_bushes(ctx)
	
	print("Successfully generated the world!")


func place_floor_tiles(ctx: GenerationContext):
	for tile in ctx.tiles():
		var biome = biomes.biome_at(tile.x, tile.y)
		match biome:
			"Ocean": ctx.set_tile(tile, GenerationContext.Terrain.Water)
			"Beach": ctx.set_tile(tile, GenerationContext.Terrain.Sand)
			"Grass": ctx.set_tile(tile, GenerationContext.Terrain.Grass)
	
	ctx.update_terrain()
	#var change_set = ctx.calculate_terrain_tiles_in_background()
	#await change_set.await_finished(get_tree())
	#change_set.apply()
 

func spawn_trees_naive(ctx: GenerationContext):
	var points = Scatter.blocking_poisson(ctx, 64, [
		ScatterFilter.rect_in_biome(ctx, biomes, "Grass", Vector2(24, 24)),
	])
	
	for point in points:
		spawn_random_tree(point, ctx)

func spawn_trees(ctx: GenerationContext):
	#var points = await Scatter.poisson(ctx, 64, [
		#ScatterFilter.remove_random(ctx, 0.25),
		#ScatterFilter.rect_in_biome(ctx, biomes, "Grass", Vector2(64, 32)),
	#]);
	var points = await Scatter.poisson(ctx, 80, [
		#ScatterFilter.remove_random(ctx, 0.25),
		ScatterFilter.rect_in_biome(ctx, biomes, "Grass", Vector2(64, 32)),
		ScatterFilter.rect_in_map(ctx, Vector2(64, 32)),
	]);
	
	for point in points:
		spawn_random_tree(point, ctx)

func spawn_bushes(ctx: GenerationContext):
	var points = await Scatter.jittered_grid(ctx, Vector2(32, 32), Vector2(32, 32), [
		ScatterFilter.remove_random(ctx, 0.5),
		ScatterFilter.rect_in_biome(ctx, biomes, "Grass", Vector2(24, 24)),
	]);
	
	for point in points:
		spawn_random_bush(point, ctx)


func spawn_random_tree(pos: Vector2, ctx: GenerationContext):
	var trunk_color = ctx.pick_random_enum_value({
		TreeAPI.TrunkColor.Brown: 9,
		TreeAPI.TrunkColor.Gray: 1,
	})
	
	var tree = ctx.spawn_tree(pos)
	tree.leaf_color = TreeAPI.LeafColor.Green
	tree.trunk_color = trunk_color

func spawn_random_bush(pos: Vector2, ctx: GenerationContext):
	var shade = ctx.pick_random_enum_value({
		BushAPI.Shade.Light: 3,
		BushAPI.Shade.Medium: 2,
		BushAPI.Shade.Dark: 1,
	})
	
	var bush = ctx.spawn_bush(pos)
	bush.shade = shade
	bush.type = BushAPI.Type.Grasslands
