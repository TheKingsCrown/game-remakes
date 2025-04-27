extends Area2D

var direction: Vector2 = Vector2.ZERO
var ball_speed: int = 300

func _process(delta):
	position += direction * ball_speed * delta

func reset():
	direction = Vector2.ZERO
	position = Vector2(565, 580)
