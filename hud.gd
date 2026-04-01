extends CanvasLayer

# Notifies Main node that the StartButton has been pressed
signal start_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# Display message in Message label temporarily
func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

# Show "Game Over" for x seconds, then return to title screen
func show_game_over():
	show_message("Game Over")
	# WAIT until the MessageTimer has counted down	
	await $MessageTimer.timeout
	# then...
	$Message.text = "Dodge the Mobs!"
	$Message.show()
	
	# make a one-shot timer and WAIT for it to finish
	# one-shot = not reset automatically once timer timeout
	await get_tree().create_timer(1.0).timeout
	# then...
	$StartButton.show()
	
	## NOTE !!
	# When you need to pause for a brief time, an alternative to using a Timer node is to use the SceneTree's create_timer() function.
	# This can be very useful to add delays such as in the above code,
	# ... where we want to wait some time before showing the "Start" button.

func update_score(score):
	$ScoreLabel.text = str(score)

func _on_start_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit()

func _on_message_timer_timeout() -> void:
	$Message.hide()
