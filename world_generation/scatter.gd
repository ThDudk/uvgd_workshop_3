class_name ScatterPoints extends Object

static func random(num_points: int, real_world_size: Vector2i, rand: RandomNumberGenerator) -> Array[Vector2]:
	var points: Array[Vector2] = []
	
	for point in range(0, num_points):
		var x = rand.randf_range(0, real_world_size.x)
		var y = rand.randf_range(0, real_world_size.y)
		points.append(Vector2(x, y))
	
	return points

static func poisson(real_world_size: Vector2i, distance: float) -> Array:
	@warning_ignore("integer_division")
	var polygon = PackedVector2Array([
		Vector2i.ZERO,
		Vector2i.RIGHT * real_world_size.x,
		real_world_size,
		Vector2i.DOWN * real_world_size.y,
	]);
	
	var points = Array(PoissonDiscSampling.generate_points_for_polygon(polygon, distance, 100))
	
	return Array(points)

static func jittered_grid(real_world_size: Vector2, rand: RandomNumberGenerator, cell_size: Vector2, jitter_strength: Vector2) -> Array[Vector2]:	
	var points: Array[Vector2] = []
	
	# this prevents points from appearing on the very edge of the world, which isn't useful
	var start_pos = cell_size / 2.0 
	
	for x in range(start_pos.x, real_world_size.x + 1, cell_size.x):
		for y in range(start_pos.y, real_world_size.y + 1, cell_size.y):
			var pos = Vector2(x, y) + Vector2(rand.randf(), rand.randf()) * jitter_strength
		
			points.append(pos)
	
	return points
