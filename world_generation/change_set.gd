class_name ChangeSet extends Object

var change_set: Dictionary

func _init(_change_set: Dictionary) -> void:
	self.change_set = _change_set

func finished():
	return BetterTerrain.is_terrain_changeset_ready(self.change_set)

func block_until_finished():
	BetterTerrain.wait_for_terrain_changeset(self.change_set)

func await_finished(tree: SceneTree):
	while not finished():
		await tree.process_frame

func apply():
	if not finished():
		push_error("Cannot apply change set, it is still generating. Please async call await_finished() or check finished() before applying.")
		return
	
	BetterTerrain.apply_terrain_changeset(self.change_set)
