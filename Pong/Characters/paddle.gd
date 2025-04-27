extends CharacterBody2D

func _process(_delta):
	velocity = Vector2.ZERO
	if Input.is_action_pressed("Down"):
		velocity = Vector2.DOWN * 350
	if Input.is_action_pressed("Up"):
		velocity = Vector2.UP * 350
	move_and_slide()
