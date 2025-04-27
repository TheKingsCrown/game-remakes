extends Area2D

const SPEED: int = 500
var direction: Vector2 = Vector2.ZERO

func _process(delta):
	position += direction * SPEED * delta


func _on_body_entered(body):
	if "hit" in body:
		body.hit()
	queue_free()

func hit():
	queue_free()


func _on_destroy_delay_timeout():
	queue_free()
