extends Area2D

# Emit this signal when it collides with an enemy
signal hit

# using @export allow us to set value in the inspector
@export var speed = 400 # how many pixel per sec player moves
var screen_size # size of game window

# Called when a node enters the scene tree
func _ready() -> void:
	screen_size = get_viewport_rect().size # to later clamp player with this region
	hide() # player hidden when game starts

# Called every frame, used to update elements of the game
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO # by default, the player's movement vector should be (0,0) aka not moving
	# check for input
	# add/subtract from velocity to obtain total direction
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	# check if player is moving or not
	if velocity.length() > 0:
		# e.g. if hold down right and down at same time, velocity vector will be (1, 1)
		# ... this leads to moving faster diagonal than e.g. horizontal movement
		# fix this by normalising
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	# move in given direction by updating player's position
	position += velocity * delta
	# restrict the player to only moving within the screen
	position = position.clamp(Vector2.ZERO, screen_size)
	
	# Play appropriate animation
	# if movement along x-axis ...
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0 # flip if go left
	# if movement along y-axis ...
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0 # flip if go down


func _on_body_entered(body: Node2D) -> void:
	hide() # player disappears after being hit
	# emits signal when hit with enemy
	hit.emit()
	# disable player's collision so don't trigger the hit signal more than once
	# set_deferred ensures only disable shape when safe to do so
	$CollisionShape2D.set_deferred("disabled", true)
	
# Call to reset the player when starting a new game
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false  # can collide again
