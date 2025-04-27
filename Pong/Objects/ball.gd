extends Area2D

var direction: Vector2 = Vector2.LEFT
var ball_speed: int = 350

func _ready():
	Globals.ball_position = position

func _process(delta):
	if Globals.in_play:
		position += direction * ball_speed * delta
		Globals.ball_position = position

func center():
	position = Globals.SCREEN_RESOLUTION/2
	Globals.ball_position = position
	ball_speed = 350
	direction.x = -direction.x
