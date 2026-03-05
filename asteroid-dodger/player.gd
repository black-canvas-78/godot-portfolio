extends Area2D

signal hit  # Signal to tell the game when player is hit

@export var speed = 400  # How fast the player moves (pixels/sec)
var screen_size  # Size of the game window

func _ready():
	screen_size = get_viewport_rect().size
	# Hide the player at start (main scene will show it)
	hide()

func _process(delta):
	var velocity = Vector2.ZERO  # The player's movement vector
	
	# Check for input
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	# Move the player
	position += velocity * delta
	
	# Clamp to screen boundaries
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func start(pos):
	"""Called when starting a new game"""
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_body_entered(body):
	"""Called when an asteroid hits the player"""
	hide()  # Player disappears after being hit
	hit.emit()
	# Disable collision so we don't get multiple hits
	$CollisionShape2D.set_deferred("disabled", true)
