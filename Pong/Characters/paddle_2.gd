extends CharacterBody2D

func _process(_delta):
	velocity = Vector2.ZERO
	if Input.is_action_pressed("Down2"):
		velocity = Vector2.DOWN * 350
	elif Input.is_action_pressed("Up2"):
		velocity = Vector2.UP * 350
	move_and_slide()
