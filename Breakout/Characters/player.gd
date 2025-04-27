extends CharacterBody2D

const PLAYER_SPEED: int = 400
var direction = Vector2.ZERO
func _process(_delta):
	velocity = Vector2.ZERO
	if Input.is_action_pressed("Left"):
		direction = Vector2.LEFT
		velocity = direction * PLAYER_SPEED
	if Input.is_action_pressed("Right"):
		direction = Vector2.RIGHT
		velocity = direction * PLAYER_SPEED
	move_and_slide()
