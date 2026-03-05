extends RigidBody2D

@export var min_speed = 150  # Minimum fall speed
@export var max_speed = 300  # Maximum fall speed

func _ready():
	# Randomize the asteroid appearance
	var asteroid_shape = $Polygon2D
	# Random color variation
	asteroid_shape.color = Color(
		randf_range(0.4, 0.6),
		randf_range(0.3, 0.5),
		randf_range(0.2, 0.4)
	)
	
	# Random rotation speed
	angular_velocity = randf_range(-3, 3)

func start(pos, velocity):
	"""Initialize the asteroid with position and velocity"""
	position = pos
	linear_velocity = velocity

func _on_visible_on_screen_notifier_2d_screen_exited():
	"""Delete asteroid when it leaves the screen"""
	queue_free()
