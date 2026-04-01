extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Play randomly decided starting animation for each new mob for diversity
	# create arr contains all the animations from the sprite frames property, ["walk", "swim", "fly"]
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	# pick a random animation from mob_types arr
	$AnimatedSprite2D.animation = mob_types.pick_random()
	$AnimatedSprite2D.play() # play animation

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# When the mob leaves the screen ...
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free() # deletes the node at the end of the frame
