class_name WorldGenerator2 extends Node

@export var raw_height: FastNoiseLite

@onready
var height = FilteredNoise.build(raw_height, [])

@onready
var biomes := Biomes.build([
	Biome.build("Ocean", BiomeCondition.noise_less_than(height, -0.1)),
	Biome.build("Sand", BiomeCondition.noise_less_than(height, 0)),
	Biome.default("Grass"),
]);

func generate(ctx: GenerationContext):
	await generate_floor(ctx)
	await scatter_trees(ctx)

func generate_floor(ctx: GenerationContext):
	for x in ctx.tile_world_size().x:
		for y in ctx.tile_world_size().y:
			var biome = biomes.biome_at(x, y)
			
			match biome:
				"Ocean": ctx.set_tile(Vector2i(x, y), GenerationContext.Terrain.Water)
				"Sand": ctx.set_tile(Vector2i(x, y), GenerationContext.Terrain.Sand)
				"Grass": ctx.set_tile(Vector2i(x, y), GenerationContext.Terrain.Grass)
	
	var changes = ctx.calculate_terrain_tiles_in_background()
	await changes.await_finished(get_tree())
	changes.apply()

func scatter_trees(ctx: GenerationContext):
	var points = await Scatter.poisson(ctx, 64, [
		ScatterFilter.rect_in_map(ctx, Vector2i(48, 32)),
		ScatterFilter.rect_in_biome(ctx, biomes, "Grass", Vector2i(24, 24))
	]);
	
	for point in points:
		var tree := ctx.spawn_tree(point)
		
		tree.trunk_color = TreeAPI.TrunkColor.Brown
		tree.leaf_color = TreeAPI.LeafColor.Green
		
