@tool
extends Sprite2D

const BUSHES = preload("uid://ckaqj3i3g4e7y")

func update_sprite(bush_api: BushAPI) -> void:
	var region = Rect2i(bush_atlas_coordinates(bush_api), Vector2i.ONE * 16)
	
	var atlas = AtlasTexture.new()
	atlas.atlas = BUSHES;
	atlas.region = region
	
	self.texture = atlas

func bush_atlas_coordinates(bush_api: BushAPI) -> Vector2i:
	var y_offset = 0
	match bush_api.type:
		BushAPI.Type.Fall: y_offset = 0
		BushAPI.Type.Desert: y_offset = 16
		BushAPI.Type.Grasslands: y_offset = 32
		BushAPI.Type.Snow: y_offset = 48
	
	var x_offset = 0
	match bush_api.shade:
		BushAPI.Shade.Light: x_offset = 0
		BushAPI.Shade.Medium: x_offset = 16
		BushAPI.Shade.Dark: x_offset = 32
	
	return Vector2i(x_offset, y_offset)
