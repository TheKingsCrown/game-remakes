extends Node2D


var laser_scene: PackedScene = preload("res://laser.tscn")
var player_scene: PackedScene = preload("res://space_ship.tscn")
var alien_scene: PackedScene = preload("res://alien.tscn")
var jelly_scene: PackedScene = preload("res://jelly_fish.tscn")

var lives: int = 3
var in_play = false
var is_dead = true
var switch = false
var move_delay_amount: float = 0.6

@onready var enemy_spawn: Vector2 = $SpawnPositions/EnemySpawn1.position

func _ready():
	loadscore()
	Globals.connect("score_changed", update_labels)
	update_labels()
	toggle_labels()
	start_game()

func _process(_delta):
	if Input.is_action_just_pressed("Start"):
		if is_dead:
			start_game()
		elif not in_play:
			respawn_player()
	if get_tree().get_nodes_in_group("Aliens").is_empty():
		enemy_spawn = $SpawnPositions/EnemySpawn1.position
		respawn_enemies()
func _on_space_ship_shoot(pos, dir, is_alien):
	create_laser(pos, dir, is_alien)

func _on_alien_shoot(pos, dir, is_alien):
	create_laser(pos, dir, is_alien)

func create_laser(pos, dir, is_alien):
	if in_play and not is_dead:
		var laser = laser_scene.instantiate() as Area2D
		if is_alien:
			laser.set_collision_mask_value(1, true)
		else:
			laser.add_to_group("PlayerLaser")
			laser.set_collision_mask_value(2, true)
		laser.position = pos
		laser.direction = dir
		$Projectiles.add_child(laser)

func start_game():
	$CanvasLayer/AnimationPlayer.stop()
	$CanvasLayer/Intructions.visible = false
	is_dead = false
	lives = 3
	Globals.score = 0
	toggle_labels()
	respawn_player()
	respawn_enemies()

func respawn_player():
	
	lives += -1
	update_labels()
	in_play = true
	var player = player_scene.instantiate() as CharacterBody2D
	player.position = $SpawnPositions/PlayerSpawn.position
	player.connect("shoot", _on_space_ship_shoot)
	player.connect("died", _on_player_died)
	$".".add_child(player)


func respawn_enemies():
	move_delay_amount = 9
	for i in range(5):
		for j in range(8):
			var alien = alien_scene.instantiate() as CharacterBody2D
			alien.position = enemy_spawn
			alien.connect("shoot", _on_alien_shoot)
			alien.connect("destroyed", hit)
			alien.add_to_group("Aliens")
			$Enemies.add_child(alien)
			enemy_spawn.x += 64
		enemy_spawn.x = $SpawnPositions/EnemySpawn1.position.x
		enemy_spawn.y += 56

func hit():
	$Audio/LaserHit.playing = true
	move_delay_amount += -0.0135

func _on_player_died():
	$Audio/LaserHit.playing = true
	if lives == 0:
		is_dead = true
		savescore()
		get_tree().call_deferred("change_scene_to_file", "res://start_screen.tscn")
	else:
		$PlayerRespawnDelay.start()

func _on_move_delay_timeout():
	if in_play:
		if not switch:
			$Audio/Move1.playing = true
			switch = not switch
		else:
			$Audio/Move2.playing = true
			switch = not switch
		$MoveDelay.set_wait_time(move_delay_amount)
		get_tree().call_group("Aliens", "_on_move")


func _on_attempt_jelly_spawn_timeout():
	if 1 == randi() % 10 and get_tree().get_nodes_in_group("JellyFish").is_empty():
		var jelly = jelly_scene.instantiate() as CharacterBody2D
		jelly.add_to_group("JellyFish")
		jelly.connect("destroyed", hit)
		jelly.position = $SpawnPositions/MotherShipSpawn1.position
		$Enemies.add_child(jelly)

func toggle_labels():
	$CanvasLayer/Score.visible = not $CanvasLayer/Score.visible
	$CanvasLayer/HighScore.visible = not $CanvasLayer/HighScore.visible
	$CanvasLayer/Lives.visible = not $CanvasLayer/Lives.visible

func update_labels():
	$CanvasLayer/Score.text = str(Globals.score)
	$CanvasLayer/HighScore.text = str(Globals.high_score)
	$CanvasLayer/Lives.text = str(lives)

func savescore():
	if Globals.score > Globals.high_score:
		Globals.high_score = Globals.score
	var file = FileAccess.open("res://savedata.dat", FileAccess.WRITE)
	file.store_64(Globals.high_score)

func loadscore():
	if not FileAccess.file_exists("res://savedata.dat"):
		savescore()
	var file = FileAccess.open("res://savedata.dat", FileAccess.READ)
	var saved_score = file.get_64()
	Globals.high_score = saved_score


func _on_player_respawn_delay_timeout():
	respawn_player()
