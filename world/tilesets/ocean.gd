extends AnimatedSprite2D

func _ready() -> void:
	for anim in self.sprite_frames.get_animation_names():
		self.sprite_frames.set_animation_loop(anim, true)
	var parent_tilemap: TileMapLayer = get_parent()

	var calc_has_cell = func has_cell(dir: Vector2i) -> bool:
		var probe_cell = parent_tilemap.local_to_map(position + (dir as Vector2) * 16)
		return parent_tilemap.get_cell_alternative_tile(probe_cell) == 1
	
	var has_up = calc_has_cell.call(Vector2i.UP)
	var has_right = calc_has_cell.call(Vector2i.RIGHT)
	var has_down = calc_has_cell.call(Vector2i.DOWN)

	if has_right:
		self.play("wave")
		self.remove_child($StaticBody2D)
	elif has_up and has_down:
		self.play("shore")
	else:
		self.play("corner_shore")
		self.flip_v = has_up
