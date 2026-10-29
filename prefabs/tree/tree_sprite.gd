@tool
extends Sprite2D

const ATLAS = preload("uid://ckhylu1hciv0q")
const SPRITE_SIZE: Vector2i = Vector2i(48, 64)

func update(api: TreeAPI) -> void:
	texture = atlas_texture(api)

func atlas_texture(api: TreeAPI) -> AtlasTexture:
	var atlas = AtlasTexture.new()
	atlas.atlas = ATLAS
	atlas.region = texture_region(api)
	
	return atlas

func texture_region(api: TreeAPI) -> Rect2i:
	var y_offset = 0
	match api.leaf_color:
		TreeAPI.LeafColor.Green: y_offset = 0
		TreeAPI.LeafColor.Pink: y_offset = SPRITE_SIZE.y
		TreeAPI.LeafColor.Red: y_offset = SPRITE_SIZE.y * 2
		TreeAPI.LeafColor.Orange: y_offset = SPRITE_SIZE.y * 3
	
	var x_offset = 0
	if api.state == TreeAPI.State.CutDown:
		x_offset = SPRITE_SIZE.x * 4
		match api.trunk_color:
			TreeAPI.TrunkColor.Brown: x_offset += 0
			TreeAPI.TrunkColor.Gray: x_offset += SPRITE_SIZE.x
	else:
		match api.trunk_color:
			TreeAPI.TrunkColor.Brown: x_offset += 0
			TreeAPI.TrunkColor.Gray: x_offset += SPRITE_SIZE.x * 2
	
		match api.state:
			TreeAPI.State.Normal: x_offset += 0
			TreeAPI.State.Snowy: x_offset += SPRITE_SIZE.x
	
	
	
	return Rect2i(x_offset, y_offset, SPRITE_SIZE.x, SPRITE_SIZE.y)
