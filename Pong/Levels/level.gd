extends Node2D

@export var player1_score: int = 0
@export var player2_score: int = 0

var player_won = false

func _ready():
	update_scores()

func _process(_delta):
	if not Globals.in_play and not player_won:
		$CanvasLayer/Text.text = "Press Enter to Serve"
		if Input.is_action_pressed("Serve"):
			Globals.in_play = true
			$CanvasLayer/Text.text = ""
		

func _on_ball_body_entered(body):
	if body == $BoundingBox/UpperBound or body == $BoundingBox/LowerBound:
		$Ball.direction.y = -$Ball.direction.y
		$wall_hit.playing = true
	else:
		$Ball.direction.x = -$Ball.direction.x
		$Ball.direction.y = randf_range(0, 1)
		$paddle_hit.playing = true
	$Ball.ball_speed += 30

func _on_right_goal_area_entered(_area):
	player1_score += 1
	update_scores()
	$score.playing = true
	$Ball.center()
	if player1_score == 5:
		$CanvasLayer/Text.text = "Player 1 Wins!"
		player_won = true
	Globals.in_play = false
func _on_left_goal_area_entered(_area):
	player2_score += 1
	update_scores()
	$score.playing = true
	$Ball.center()
	if player2_score == 5:
		$CanvasLayer/Text.text = "Player 2 Wins!"
		player_won = true
	Globals.in_play = false

func update_scores():
	$CanvasLayer/Player1Score.text = str(player1_score)
	$CanvasLayer/Player2Score.text = str(player2_score)
