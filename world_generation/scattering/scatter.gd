class_name Scatter extends Object

static func blocking_random(ctx: GenerationContext, num_points: int, filters: Array[ScatterFilter]) -> PackedVector2Array:
	var points = []
	
	for point in range(0, num_points):
		var x = ctx.randf_range(0, ctx.real_world_size().x)
		var y = ctx.randf_range(0, ctx.real_world_size().y)
		points.append(Vector2(x, y))
	
	for filter in filters:
		points = filter.filter(points)
	
	return points

## NOTE: `filters` must not be accessed after being input. This may cause the program to crash.
static func random(ctx: GenerationContext, num_points: int, filters: Array[ScatterFilter]) -> PackedVector2Array:
	var real_world_size = ctx.real_world_size()
	var rand = RandomNumberGenerator.new()
	rand.seed = ctx.random.seed
	rand.state = ctx.random.state
	
	# I'm using points[0] here so it doesn't get copied into the closure. 
	# This forces it to use a reference, so points[0] gets changed, not some cloned variable that gets thrown out.
	# (I miss rust :cry:)
	var points = [[]] 
	var task_id = WorkerThreadPool.add_task(func():
		for point in range(0, num_points):
			var x = rand.randf_range(0, real_world_size.x)
			var y = rand.randf_range(0, real_world_size.y)
			points[0].append(Vector2(x, y))
		
		for filter in filters:
			points[0] = filter.filter(points[0])
	)
	
	while not WorkerThreadPool.is_task_completed(task_id):
		await ctx.scene_tree.process_frame
	
	ctx.state = rand.state # update ctx.random
	
	# explicitely wait. The task should be done, so this shouldn't take any time.
	# This just lets the thread-pool deallocate resources
	WorkerThreadPool.wait_for_task_completion(task_id)
	
	return points[0]

static func blocking_poisson(ctx: GenerationContext, distance: float, filters: Array[ScatterFilter]) -> PackedVector2Array:
	@warning_ignore("integer_division")
	var polygon = PackedVector2Array([
		Vector2i.ZERO,
		Vector2i.RIGHT * ctx.real_world_size().x,
		ctx.real_world_size(),
		Vector2i.DOWN * ctx.real_world_size().y,
	]);
	
	var points = Array(PoissonDiscSampling.generate_points_for_polygon(polygon, distance, 100))
	
	for filter in filters:
		points = filter.filter(points)
	
	return points

## NOTE: `filters` must not be accessed after being input. This may cause the program to crash.
static func poisson(ctx: GenerationContext, distance: float, filters: Array[ScatterFilter]) -> PackedVector2Array:
	@warning_ignore("integer_division")
	var polygon = PackedVector2Array([
		Vector2i.ZERO,
		Vector2i.RIGHT * ctx.real_world_size().x,
		ctx.real_world_size(),
		Vector2i.DOWN * ctx.real_world_size().y,
	]);
	
	# I'm using points[0] here so it doesn't get copied into the closure. 
	# This forces it to use a reference, so points[0] gets changed, not some cloned variable that gets thrown out.
	# (I miss rust :cry:)
	var points = [[]] 
	var task_id = WorkerThreadPool.add_task(func():
		points[0] = Array(PoissonDiscSampling.generate_points_for_polygon(polygon, distance, 100))
	
		for filter in filters:
			points[0] = filter.filter(points[0])
	)
	
	while not WorkerThreadPool.is_task_completed(task_id):
		await ctx.scene_tree.process_frame
	
	# explicitely wait. The task should be done, so this shouldn't take any time.
	# This just lets the thread-pool deallocate resources
	WorkerThreadPool.wait_for_task_completion(task_id)
	
	return points[0]

static func blocking_jittered_grid(ctx: GenerationContext, cell_size: Vector2, jitter_strength: Vector2, filters: Array[ScatterFilter]) -> PackedVector2Array:	
	var points: PackedVector2Array = []
	
	# this prevents points from appearing on the very edge of the world, which isn't useful
	var start_pos = cell_size / 2.0 
	
	for x in range(start_pos.x, ctx.real_world_size().x + 1, cell_size.x):
		for y in range(start_pos.y, ctx.real_world_size().y + 1, cell_size.y):
			var pos = Vector2(x, y) + Vector2(ctx.randf(), ctx.randf()) * jitter_strength
		
			points.append(pos)
	
	for filter in filters:
		points = filter.filter(points)
	
	return points

## NOTE: `filters` must not be accessed outside after being input. This may cause the program to crash.
static func jittered_grid(ctx: GenerationContext, cell_size: Vector2, jitter_strength: Vector2, filters: Array[ScatterFilter]) -> PackedVector2Array:	
	# Create copies of data in ctx for the worker thread.
	var real_world_size = ctx.real_world_size()
	var rand = RandomNumberGenerator.new()
	rand.seed = ctx.random.seed
	rand.state = ctx.random.state
	
	var filters_safe = filters.duplicate_deep(Resource.DeepDuplicateMode.DEEP_DUPLICATE_ALL)
	
	# I'm using points[0] here so it doesn't get copied into the closure. 
	# This forces it to use a reference, so points[0] gets changed, not some cloned variable that gets thrown out.
	# (I miss rust :cry:)
	var points = [[]]
	var task_id = WorkerThreadPool.add_task(func():
		# this prevents points from appearing on the very edge of the world, which isn't useful
		var start_pos = cell_size / 2.0 
		
		for x in range(start_pos.x, real_world_size.x + 1, cell_size.x):
			for y in range(start_pos.y, real_world_size.y + 1, cell_size.y):
				var pos = Vector2(x, y) + Vector2(rand.randf(), rand.randf()) * jitter_strength
			
				points[0].append(pos)
		
		for filter in filters_safe:
			points[0] = filter.filter(points[0])
	);
	
	while not WorkerThreadPool.is_task_completed(task_id):
		await ctx.scene_tree.process_frame
	
	ctx.state = rand.state # update ctx.random
	
	# explicitely wait. The task should be done, so this shouldn't take any time.
	# This just lets the thread-pool deallocate resources
	WorkerThreadPool.wait_for_task_completion(task_id)
	
	return points[0]
