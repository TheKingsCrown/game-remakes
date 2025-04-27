extends CharacterBody2D

signal shoot(pos, dir, is_alien)
signal destroyed()

var move_amount: Vector2 = Vector2(20, 56)
var can_move_down = true
var is_moving_down = false

func _ready():
	$ShootDelay.start()
	Globals.connect("move", _on_move)
func hit():
	destroyed.emit()
	Globals.score += 10
	queue_free()

func _on_shoot_delay_timeout():
	if 1 == randi() % 25 and not $RayCast2D.is_colliding():
		shoot.emit($Marker2D.global_position, Vector2.DOWN, true)

func move_down():
	if can_move_down:
		can_move_down = false
		is_moving_down = true
		move_amount.x = -move_amount.x
		position.y += move_amount.y
		is_moving_down = false

func _on_move():
	if (global_position.x >= 1230 or global_position.x <= 50) and can_move_down:
		get_tree().call_group("Aliens", "move_down")
	else:
		position.x += move_amount.x
		can_move_down = true
