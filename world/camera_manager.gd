extends Node

# STATE

enum CameraStateKind {
	# No camera exists
	NONE,
	# Camera exists but it doesn't know what to do
	UNKNOWN,
	# Camera exists and should follow a given entity
	FOLLOW,
	# Camera exists and is being controlled explicitly
	CONTROLLED,
}

class CameraState:
	var kind: CameraStateKind = CameraStateKind.NONE
	var instance: Camera2D = null
	var owner: Node = null

	# Follow
	var target: Node2D = null
	var deadzone: Vector2i = Vector2i.ZERO

var _state = CameraState.new()

# API

func register_camera(entity: Camera2D) -> void:
	assert(_state.kind == CameraStateKind.NONE, "trying to register second camera")
	_state.kind = CameraStateKind.UNKNOWN
	_state.instance = entity

func unregister_camera(entity: Camera2D) -> void:
	assert(_state.kind != CameraStateKind.NONE, "trying to unregister camera when no camera is registered")
	assert(_state.instance == entity, "tried to unregister incorrect camera")
	_state.kind = CameraStateKind.NONE
	_state.instance = null

func is_unowned() -> bool:
	return _state.kind == CameraStateKind.UNKNOWN and _state.owner == null

func is_owner(entity: Node) -> bool:
	return _state.owner == entity

func try_claim(entity: Node) -> bool:
	if !is_unowned():
		return false
	_state.owner = entity
	return true

func drop(entity: Node) -> bool:
	if _state.owner != entity:
		return false
	_state.kind = CameraStateKind.UNKNOWN
	_state.owner = null
	return true

func set_following(entity: Node, target: Node2D = null, deadzone: Vector2i = Vector2i.ZERO) -> bool:
	if entity != _state.owner:
		return false
	
	_state.kind = CameraStateKind.FOLLOW
	_state.target = target
	_state.deadzone = deadzone
	
	return true

# LOGIC

func _invariants() -> void:
	assert(_state.owner == null or _state.kind != CameraStateKind.UNKNOWN, "camera is owned but in unknown state")
	assert(_state.kind == CameraStateKind.NONE or _state.instance != null, "camera exists but has no instance")

func _process_follow(delta: float) -> void:
	if _state.target == null:
		return
	var target_gpos: Vector2i = _state.target.global_position.round() as Vector2i
	var my_gpos: Vector2i = _state.instance.global_position.round() as Vector2i
	assert((my_gpos as Vector2).distance_squared_to(_state.instance.global_position) < 0.01, "something fucky in camera pos")

	if target_gpos.x + _state.deadzone.x < my_gpos.x:
		_state.instance.global_position.x = target_gpos.x + _state.deadzone.x
	if target_gpos.x - _state.deadzone.x > my_gpos.x:
		_state.instance.global_position.x = target_gpos.x + _state.deadzone.x
	if target_gpos.y + _state.deadzone.y < my_gpos.y:
		_state.instance.global_position.y = target_gpos.y + _state.deadzone.y
	if target_gpos.y - _state.deadzone.y > my_gpos.y:
		_state.instance.global_position.y = target_gpos.y + _state.deadzone.y
	
	
func _process(delta: float) -> void:
	_invariants()

	match _state.kind:
		CameraStateKind.FOLLOW:
			_process_follow(delta)
