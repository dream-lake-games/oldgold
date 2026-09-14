class_name World extends Node2D

# PARTS

@onready var _camera: Camera2D = $Camera
@onready var _goldeo: Goldeo = $Goldeo

# KNOBS

@export var deadzone: Vector2i = Vector2i(32, 16)

# STATE

# LOGIC

func _ready() -> void:
	CameraManager.register_camera(_camera)
	assert(CameraManager.try_claim(self), "world can't claim camera in ready")
	CameraManager.set_following(self, _goldeo, deadzone)

func _exit_tree() -> void:
	CameraManager.drop(self)
	CameraManager.unregister_camera(_camera)
