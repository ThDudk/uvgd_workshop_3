@tool
extends Sprite2D

const ATLAS = preload("uid://dpqs6avvfnwcm")
const SPRITE_SIZE: Vector2i = Vector2i(32, 32)

func update(api: LargeCactusAPI) -> void:
	var atlas = AtlasTexture.new()
	atlas.atlas = ATLAS;
	atlas.region = atlas_region(api)
	
	self.texture = atlas

func atlas_region(api: LargeCactusAPI) -> Rect2i:
	var y_offset = 16
	match api.type:
		LargeCactusAPI.Type.Green: y_offset += 0
		@warning_ignore("integer_division")
		LargeCactusAPI.Type.Brown: y_offset += 48
	
	var x_offset = 0
	match api.state:
		LargeCactusAPI.State.Plain: x_offset += 0
		@warning_ignore("integer_division")
		LargeCactusAPI.State.Flowering: x_offset += 32
	
	return Rect2i(x_offset, y_offset, SPRITE_SIZE.x, SPRITE_SIZE.y)
