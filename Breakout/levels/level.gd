extends Node2D

var lives: int = 3
var score: int = 0
var high_score: int = 0
var in_play = false
var is_dead = false

func _ready():
	loadscore()
	update_score()

func _process(_delta):
	if Input.is_action_just_pressed("Start") and not in_play:
		if not is_dead:
			$Ball.direction = Vector2.UP
			$Ball.direction.x = randf_range(-1, 1)
			in_play = true
		if is_dead:
			reset()

func _on_ball_body_entered(body):
	if body == $Borders/LeftBorder or body == $Borders/RightBorder:
		$Ball.direction.x = -$Ball.direction.x
	elif body == $Borders/LowerBorder:
		lives += -1
		if lives == 0:
			is_dead = true
			savescore()
		$CanvasLayer/Lives.text = "Lives: " + str(lives)
		$Ball.reset()
		in_play = false
	elif body == $Player or body == $Borders/UpperBorder:
		if in_play:
			$Ball.direction.y = -$Ball.direction.y
			if body == $Borders/UpperBorder:
				$Player.scale.x = 0.5
			else:
				$Ball.direction.x = body.direction.x
	else:
		collide_with_brick(body)

func collide_with_brick(body):
	score += 3
	update_score()
	if ($Ball.global_position.x > body.global_position.x and $Ball.direction.x < 0) or ($Ball.global_position.x < body.global_position.x - 50 and $Ball.direction.x > 0):
		$Ball.direction.x = -$Ball.direction.x
		body.queue_free()
	elif ($Ball.global_position.y > body.global_position.y and $Ball.direction.y < 0) or ($Ball.global_position.y < body.global_position.y - 8 and $Ball.direction.y > 0):
		$Ball.direction.y = -$Ball.direction.y
		body.queue_free()

func update_score():
	$CanvasLayer/CurrentScore.text = "Current Score: " + str(score)
	if score > high_score:
		high_score = score
	$CanvasLayer/HighScore.text = "High Score: " + str(high_score)

func reset():
	$Player.position = Vector2(565, 600)
	$Ball.reset()
	is_dead = false
	#if score > high_score:
	
	score = 0
	update_score()
	lives = 3
	$CanvasLayer/Lives.text = "Lives: " + str(lives)

func savescore():
	var file = FileAccess.open("res://savedata.dat", FileAccess.WRITE)
	file.store_64(high_score)

func loadscore():
	if not FileAccess.file_exists("res://savedata.dat"):
		savescore()
	var file = FileAccess.open("res://savedata.dat", FileAccess.READ)
	var saved_score = file.get_64()
	high_score = saved_score
