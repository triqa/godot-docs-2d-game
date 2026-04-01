extends Node

# can now choose the mob scene want to instance
@export var mob_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()

# MobTimer timeout leads to another mob spawning
func _on_mob_timer_timeout() -> void:
	# create a new instance of the Mob scene
	var mob = mob_scene.instantiate()
	
	# get a random location on Path2D
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf() # (?) select rando location along this
	# set mob's position to the above random location
	mob.position = mob_spawn_location.position
	
	# set the mob's direction perpendicular to the path direction
	var direction = mob_spawn_location.rotation + PI / 2
	# add randomness to the direction
	direction += randf_range(-PI / 4, PI /4)
	mob.rotation = direction
	
	# choose velocity for the mob
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# spawn the mob by adding to Main scene
	add_child(mob)

# ScoreTimer increments the score every second
func _on_score_timer_timeout() -> void:
	score += 1

# StartTimer gives a delay before starting game
func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
