class_name World extends Node2D

# PARTS

@onready var _camera: Camera2D = $Camera
@onready var _goldeo: Goldeo = $Goldeo
@onready var _map: AnimatedSprite2D = $Map

# KNOBS

@export var deadzone: Vector2i = Vector2i(16, 12)

# STATE

# LOGIC

func _ready() -> void:
	CameraManager.register_camera(_camera)
	assert(CameraManager.try_claim(self), "world can't claim camera in ready")
	CameraManager.set_following(self, _goldeo, deadzone)
	var bounds = _map.get_viewport_rect()
	bounds.position -= _map.get_viewport_rect().size / 2
	bounds.position *= _map.transform.get_scale().x
	bounds.size *= _map.transform.get_scale().x
	CameraManager.set_bounds(self, bounds)

func _exit_tree() -> void:
	CameraManager.drop(self)
	CameraManager.unregister_camera(_camera)
