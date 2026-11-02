class_name WorldGenerator extends Node

@export var raw_height: FastNoiseLite
@export var raw_temperature: FastNoiseLite

func height_at(x: int, y: int) -> float:
	return raw_height.get_noise_2d(x, y)

func temp_at(x: int, y: int) -> float:
	return raw_temperature.get_noise_2d(x, y)

func biome_at(x: int, y: int) -> String:
	var height = height_at(x, y)
	
	if height < -0.1:
		return "Ocean"
	elif height < 0.1:
		return "Sand"
	else:
		var temp = temp_at(x, y)
		
		if temp < -0.5:
			return "Desert"
		elif temp < 0.3:
			return "Fall"
		else:
			return "Grass"


func generate(ctx: GenerationContext):
	await generate_floor(ctx)

	await scatter_trees(ctx)
	await scatter_bushes(ctx)
	await scatter_desert_objects(ctx)

func generate_floor(ctx: GenerationContext):
	for x in ctx.tile_world_size().x:
		for y in ctx.tile_world_size().y:
			var biome = biome_at(x, y)
			
			match biome:
				"Ocean": ctx.set_tile(Vector2i(x, y), GenerationContext.Terrain.Water)
				"Sand": ctx.set_tile(Vector2i(x, y), GenerationContext.Terrain.Sand)
				"Desert": ctx.set_tile(Vector2i(x, y), GenerationContext.Terrain.Sand)
				"Fall": ctx.set_tile(Vector2i(x, y), GenerationContext.Terrain.Fall)
				"Grass": ctx.set_tile(Vector2i(x, y), GenerationContext.Terrain.Grass)
	
	var changes = ctx.calculate_terrain_tiles_in_background()
	await changes.await_finished(get_tree())
	changes.apply()

func scatter_desert_objects(ctx: GenerationContext):
	var large_cacti = await cacti_scatter_points(ctx.thread_safe_ctx())
	#var small_cacti = await small_cacti_scatter_points(ctx.thread_safe_ctx())
	
	for pos in large_cacti:
		ctx.spawn_large_cactus(pos)
	

func scatter_trees(ctx: GenerationContext):
	var points = await tree_scatter_points(ctx.thread_safe_ctx())
	
	for point in points:
		var tree := ctx.spawn_tree(point)
		
		tree.trunk_color = TreeAPI.TrunkColor.Brown
		tree.leaf_color = TreeAPI.LeafColor.Green

func scatter_bushes(ctx: GenerationContext):
	var points = await bush_scatter_points(ctx.thread_safe_ctx())
	
	for point in points:
		ctx.spawn_bush(point)



func tree_scatter_points(ctx: SafeGenerationContext) -> Array:
	var points = [[]]
	var task_id := WorkerThreadPool.add_task(func():
		var rand = ctx.lock_random()
		var positions = ScatterPoints.poisson(ctx.real_world_size(), 64)
	
		points[0] = positions.filter(func(world_pos):
			return (
				ctx.rect_in_map(world_pos, Vector2i(48, 32))
				and ctx.rect_in_biome(world_pos, Vector2i(48, 32), biome_at, "Grass")
				and rand.randf() < 0.95
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

func cacti_scatter_points(ctx: SafeGenerationContext) -> Array:
	var points = [[]]
	var task_id := WorkerThreadPool.add_task(func():
		var rand = ctx.lock_random()
		var positions = ScatterPoints.poisson(ctx.real_world_size(), 64)
	
		points[0] = positions.filter(func(world_pos):
			return (
				ctx.rect_in_map(world_pos, Vector2i(16, 16))
				and ctx.rect_in_biome(world_pos, Vector2i(16, 16), biome_at, "Desert")
				and rand.randf() < 0.25
			)
		)
		ctx.unlock_random()
	)
	
	while not WorkerThreadPool.is_task_completed(task_id):
		await get_tree().process_frame
	
	WorkerThreadPool.wait_for_task_completion(task_id)
	
	return points[0]
