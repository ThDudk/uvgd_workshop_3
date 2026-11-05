class_name DemoWorldGenerator extends Node

@export var raw_height: FastNoiseLite

func height_at(x: int, y: int) -> float:
	return raw_height.get_noise_2d(x, y)

func biome_at(x: int, y: int) -> String:
	var height = height_at(x, y)
	
	if height < -0.1:
		return "Ocean"
	elif height < 0.1:
		return "Sand"
	else:
		return "Grass"


func generate(ctx: GenerationContext):	
	raw_height.seed = ctx.world_seed
	
	await generate_floor(ctx)

	await scatter_trees(ctx)
	await scatter_bushes(ctx)

func generate_floor(ctx: GenerationContext):
	for x in ctx.tile_world_size().x:
		for y in ctx.tile_world_size().y:
			var biome = biome_at(x, y)
			
			match biome:
				"Ocean": ctx.set_tile(Vector2i(x, y), GenerationContext.Terrain.Water)
				"Sand": ctx.set_tile(Vector2i(x, y), GenerationContext.Terrain.Sand)
				"Grass": ctx.set_tile(Vector2i(x, y), GenerationContext.Terrain.Grass)
	
	var changes = ctx.calculate_terrain_tiles_in_background()
	await changes.await_finished(get_tree())
	changes.apply()	

func scatter_trees(ctx: GenerationContext):
	var points = await tree_scatter_points(ctx.thread_safe_ctx())
	
	for point in points:
		var tree := ctx.spawn_tree(point)
		
		tree.trunk_color = TreeAPI.TrunkColor.Brown
		
		tree.leaf_color = [
			TreeAPI.LeafColor.Green, 
			TreeAPI.LeafColor.Orange,
			TreeAPI.LeafColor.Red,
			TreeAPI.LeafColor.Pink,
		].get(ctx.random.rand_weighted(
			[5, 3, 2, 1]
		));

func scatter_bushes(ctx: GenerationContext):
	var points = await bush_scatter_points(ctx.thread_safe_ctx())
	
	for point in points:
		var bush = ctx.spawn_bush(point)
		
		bush.shade = ctx.random.rand_weighted([1, 3, 1])
		
		var type_idx = ctx.random.rand_weighted([1, 9])
		bush.type = [BushAPI.Type.Fall, BushAPI.Type.Grasslands].get(type_idx)



func tree_scatter_points(ctx: SafeGenerationContext) -> Array:
	var points = [[]]
	var task_id := WorkerThreadPool.add_task(func():
		var rand = ctx.lock_random()
		var positions = ScatterPoints.poisson(ctx.real_world_size(), 64)
	
		points[0] = positions.filter(func(world_pos):
			return (
				ctx.rect_in_map(world_pos, Vector2i(48, 32))
				and ctx.rect_in_biome(world_pos, Vector2i(64, 32), biome_at, "Grass")
				and rand.randf() < 0.90
			)
		)
		ctx.unlock_random()
	)
	
	while not WorkerThreadPool.is_task_completed(task_id):
		await get_tree().process_frame
	
	WorkerThreadPool.wait_for_task_completion(task_id)
	
	return points[0]

func bush_scatter_points(ctx: SafeGenerationContext) -> Array:	
	var points = [[]]
	var task_id := WorkerThreadPool.add_task(func():
		var rand = ctx.lock_random()
		var positions = ScatterPoints.jittered_grid(ctx.real_world_size(), rand, Vector2(64, 64), Vector2(32, 32))
	
		points[0] = positions.filter(func(world_pos):
			return (
				ctx.rect_in_map(world_pos, Vector2i(8, 8))
				and ctx.rect_in_biome(world_pos, Vector2i(8, 8), biome_at, "Grass")
				and rand.randf() < 0.2
			)
		)
		ctx.unlock_random()
	)
	
	while not WorkerThreadPool.is_task_completed(task_id):
		await get_tree().process_frame
	
	WorkerThreadPool.wait_for_task_completion(task_id)
	
	return points[0]
