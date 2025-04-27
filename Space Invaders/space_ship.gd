extends CharacterBody2D

signal shoot(pos, dir, is_alien)
signal died()

const PLAYER_SPEED: int = 500
const STARTING_POSITION: Vector2 = Vector2(640, 660)
var direction = Vector2.ZERO

func _process(delta):
	velocity = Vector2.ZERO
	if Input.is_action_pressed("Left"):
		direction = Vector2.LEFT
		velocity = direction * PLAYER_SPEED
	elif Input.is_action_pressed("Right"):
		direction = Vector2.RIGHT
		velocity = direction * PLAYER_SPEED
	move_and_slide()
	if Input.is_action_just_pressed("Shoot"):
		if get_tree().get_nodes_in_group("PlayerLaser").is_empty():
			shoot.emit($Marker2D.global_position, Vector2.UP, false)
			$LaserShot.playing = true

func hit():
	died.emit()
	queue_free()
