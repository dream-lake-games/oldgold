class_name Goldeo extends CharacterBody2D

# KNOBS

@export var speed := 85

# PARTS

@onready var anim: AnimatedSprite2D = $Anim


# STATE

enum Facing {
	LEFT,
	RIGHT,
	UP,
	DOWN,
}
var facing := Facing.DOWN

# LOGIC

func _process_facing() -> void:
	if velocity.length_squared() > 0.1:
		if velocity.x != 0:
			facing = Facing.RIGHT if velocity.x > 0 else Facing.LEFT
		elif velocity.y > 0:
			facing = Facing.DOWN
		else:
			facing = Facing.UP


func _process_anim() -> void:
	var is_moving = velocity.length_squared() > 0.1
	match facing:
		Facing.LEFT:
			anim.flip_h = true
			anim.play("e_run" if is_moving else "e_idle")
		Facing.RIGHT:
			anim.flip_h = false
			anim.play("e_run" if is_moving else "e_idle")
		Facing.UP:
			anim.flip_h = false
			anim.play("n_run" if is_moving else "n_idle")
		Facing.DOWN:
			anim.flip_h = false
			anim.play("s_run" if is_moving else "s_idle")


func _process(delta: float) -> void:
	_process_facing()
	_process_anim()

	if Input.is_action_just_pressed("a"):
		self.z_index -= 1
		self.z_index = max(self.z_index, 1)
		print(self.z_index)
	if Input.is_action_just_pressed("b"):
		self.z_index += 1
		print(self.z_index)
	for ix in range(1, 32):
		set_collision_layer_value(ix, self.z_index == ix)
		set_collision_mask_value(ix, self.z_index == ix)


func _physics_process(delta: float) -> void:
	var input_dir = Input.get_vector("left", "right", "up", "down").normalized()

	if input_dir.length_squared() > 0.1:
		velocity = input_dir * speed
		if velocity.y > 0:
			facing = Facing.DOWN
		elif velocity.x != 0:
			facing = Facing.RIGHT if velocity.x > 0 else Facing.LEFT
		else:
			facing = Facing.UP
	else:
		velocity = Vector2.ZERO

	move_and_slide()
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("a"):
		var nearest_actionable := DialogueActionable2D.get_nearest_actionable_to(global_position)
		if nearest_actionable and nearest_actionable.overlaps_body(self):
			nearest_actionable.action()
			

		
		
		
