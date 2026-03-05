extends Node

@export var asteroid_scene: PackedScene  # Will load asteroid scene

var score = 0

@onready var player = $Player
@onready var score_label = $CanvasLayer/ScoreLabel
@onready var message_label = $CanvasLayer/MessageLabel
@onready var asteroid_timer = $AsteroidTimer
@onready var score_timer = $ScoreTimer
@onready var start_timer = $StartTimer
@onready var start_position = $StartPosition

func _ready():
	# Load the asteroid scene
	asteroid_scene = load("res://asteroid.tscn")

func new_game():
	"""Start a new game"""
	score = 0
	score_label.text = str(score)
	
	# Start the player
	player.start(start_position.position)
	
	# Show "Get Ready!" message
	message_label.text = "Get Ready!"
	message_label.show()
	
	# Start the countdown
	start_timer.start()

func game_over():
	"""End the game"""
	score_timer.stop()
	asteroid_timer.stop()
	message_label.text = "Game Over!\nScore: " + str(score) + "\n\nPress Enter to Restart"
	message_label.show()
	
	# Clear all asteroids
	get_tree().call_group("asteroids", "queue_free")

func _process(_delta):
	# Check for restart input
	if Input.is_action_just_pressed("ui_accept"):
		if not player.visible:
			new_game()

func _on_start_timer_timeout():
	"""Called when countdown finishes"""
	asteroid_timer.start()
	score_timer.start()
	message_label.hide()

func _on_asteroid_timer_timeout():
	"""Spawn a new asteroid"""
	var asteroid = asteroid_scene.instantiate()
	
	# Random position along top of screen
	var asteroid_spawn_location = Vector2(
		randf_range(0, get_viewport().get_visible_rect().size.x),
		0
	)
	
	# Random direction pointing downward
	var direction = Vector2(randf_range(-0.5, 0.5), 1.0)
	var velocity = direction.normalized() * randf_range(150, 300)
	
	asteroid.start(asteroid_spawn_location, velocity)
	
	# Add to "asteroids" group for easy cleanup
	asteroid.add_to_group("asteroids")
	
	add_child(asteroid)

func _on_score_timer_timeout():
	"""Increase score every second"""
	score += 1
	score_label.text = str(score)

func _on_player_hit():
	"""Called when player gets hit"""
	game_over()
