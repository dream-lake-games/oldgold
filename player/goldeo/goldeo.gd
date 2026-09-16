class_name Goldeo extends CharacterBody2D

# PARTS

@onready var anim: AnimatedSprite2D = $Anim

# KNOBS

@export var speed := 85

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
			

		
		
		
