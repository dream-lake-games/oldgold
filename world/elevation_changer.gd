class_name ElevationGainer extends Node2D

# KNOBS

@export var up_z: int = -1
@export var left_z: int = -1
@export var down_z: int = -1
@export var right_z: int = -1

# PARTS

@onready var up_area: Area2D = $UpArea
@onready var left_area: Area2D = $LeftArea
@onready var down_area: Area2D = $DownArea
@onready var right_area: Area2D = $RightArea

func _is_playerlike(node: Node2D) -> bool:
	return node.is_in_group("goldeo")

func _physics_process(_delta: float) -> void:
	var up_overlapping: Array[Node2D] = up_area.get_overlapping_bodies().filter(_is_playerlike)
	var is_up_occupied = up_overlapping.size() > 0
	var left_overlapping: Array[Node2D] = left_area.get_overlapping_bodies().filter(_is_playerlike)
	var is_left_occupied = left_overlapping.size() > 0
	var down_overlapping: Array[Node2D] = down_area.get_overlapping_bodies().filter(_is_playerlike)
	var is_down_occupied = down_overlapping.size() > 0
	var right_overlapping: Array[Node2D] = right_area.get_overlapping_bodies().filter(_is_playerlike)
	var is_right_occupied = right_overlapping.size() > 0

	if is_up_occupied && !is_down_occupied && up_z >= 0:
		for node in up_overlapping:
			var goldeo: Goldeo = node
			goldeo.z_index = up_z
	if !is_up_occupied && is_down_occupied && down_z >= 0:
		for node in down_overlapping:
			var goldeo: Goldeo = node
			goldeo.z_index = down_z
	if is_left_occupied && !is_right_occupied && left_z >= 0:
		for node in left_overlapping:
			var goldeo: Goldeo = node
			goldeo.z_index = left_z
	if !is_left_occupied && is_right_occupied && right_z >= 0:
		for node in right_overlapping:
			var goldeo: Goldeo = node
			goldeo.z_index = right_z
