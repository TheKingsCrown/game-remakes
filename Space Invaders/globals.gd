extends Node

signal move
signal score_changed

var score = 0:
	set(value):
		score = value
		score_changed.emit()
		if score > high_score:
			high_score = score
var high_score = 0:
	set(value):
		high_score = value
		score_changed.emit()
