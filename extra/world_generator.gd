class_name WorldGenerator extends Node

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
	await generate_floor(ctx)
	await scatter_objects(ctx)

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

func tree_scatter_points(ctx: SafeGenerationContext, points: Array) -> int:
	var rand = ctx.lock_random()
	
	var task_id := WorkerThreadPool.add_task(func():
		var positions = ScatterPoints.poisson(ctx.real_world_size(), 64)
	
		points[0] = positions.filter(func(world_pos):
			return (
				ctx.rect_in_map(world_pos, Vector2i(48, 32))
				and ctx.rect_in_biome(world_pos, Vector2i(48, 32), biome_at, "Grass")
				and rand.randf() < 0.95
			)
		)
	)
	
	ctx.unlock_random()
	return task_id

func bush_scatter_points(ctx: SafeGenerationContext, points: Array) -> int:
	var rand = ctx.lock_random()
	
	var task_id := WorkerThreadPool.add_task(func():
		var positions = ScatterPoints.jittered_grid(ctx.real_world_size(), rand, Vector2(64, 64), Vector2(32, 32))
	
		points[0] = positions.filter(func(world_pos):
			return (
				ctx.rect_in_map(world_pos, Vector2i(8, 8))
				and ctx.rect_in_biome(world_pos, Vector2i(8, 8), biome_at, "Grass")
				and ctx.random.randf() < 0.2
			)
		)
	)
	
	ctx.unlock_random()
	return task_id

func scatter_objects(ctx: GenerationContext):
	var tree_points = [[]]
	var bush_points = [[]]
	var tree_task_id = tree_scatter_points(ctx.thread_safe_ctx(), tree_points)
	var bush_task_id = bush_scatter_points(ctx.thread_safe_ctx(), bush_points)
	
	while not WorkerThreadPool.is_task_completed(tree_task_id) or not WorkerThreadPool.is_task_completed(bush_task_id):
		await get_tree().process_frame
	
	WorkerThreadPool.wait_for_task_completion(tree_task_id)
	WorkerThreadPool.wait_for_task_completion(bush_task_id)
	
	for point in tree_points[0]:
		var tree := ctx.spawn_tree(point)
		
		tree.trunk_color = TreeAPI.TrunkColor.Brown
		tree.leaf_color = TreeAPI.LeafColor.Green
	
	for point in bush_points[0]:
		ctx.spawn_bush(point)
