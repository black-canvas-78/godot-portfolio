extends Node2D

# Game variables
var coins = 0
var click_value = 1
var upgrade_cost = 10
var upgrade_multiplier = 1.5

# References to UI elements
@onready var score_label = $VBoxContainer/ScoreLabel
@onready var click_button = $VBoxContainer/ClickButton
@onready var info_label = $VBoxContainer/InfoLabel
@onready var upgrade_button = $VBoxContainer/UpgradeButton

func _ready():
	# Connect button signals to functions
	click_button.pressed.connect(_on_click_button_pressed)
	upgrade_button.pressed.connect(_on_upgrade_button_pressed)
	
	# Initial UI update
	update_ui()

func _on_click_button_pressed():
	# Add coins based on click value
	coins += click_value
	
	# Add a simple animation - make button slightly bigger then back
	var tween = create_tween()
	tween.tween_property(click_button, "scale", Vector2(1.1, 1.1), 0.1)
	tween.tween_property(click_button, "scale", Vector2(1.0, 1.0), 0.1)
	
	update_ui()

func _on_upgrade_button_pressed():
	# Check if player can afford upgrade
	if coins >= upgrade_cost:
		coins -= upgrade_cost
		click_value += 1
		upgrade_cost = int(upgrade_cost * upgrade_multiplier)
		
		# Flash the upgrade button green
		var original_color = upgrade_button.modulate
		var tween = create_tween()
		tween.tween_property(upgrade_button, "modulate", Color.GREEN, 0.1)
		tween.tween_property(upgrade_button, "modulate", original_color, 0.1)
		
		update_ui()

func update_ui():
	# Update all text labels
	score_label.text = "Coins: " + str(coins)
	info_label.text = "Click value: " + str(click_value)
	upgrade_button.text = "Upgrade Click (Cost: " + str(upgrade_cost) + ")"
	
	# Disable upgrade button if can't afford
	upgrade_button.disabled = coins < upgrade_cost
