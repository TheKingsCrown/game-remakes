extends CharacterBody2D

signal destroyed()

var direction: Vector2 = Vector2.RIGHT
const SPEED: int = 350

func _process(_delta):
	velocity = direction * SPEED
	move_and_slide()


func _on_delete_delay_timeout():
	queue_free()

func hit():
	destroyed.emit()
	Globals.score += 300
	queue_free()
