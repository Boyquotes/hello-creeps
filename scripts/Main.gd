extends Node

var score

export (PackedScene) var Mob

func _ready():
	randomize()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	
	$HUD.show_game_over()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()


func _on_ScoreTimer_timeout():
	score += 1
	
	$HUD.update_score(score)


func _on_MobTimer_timeout():
	# Random spawn-location on path
	$MobPath/MobSpawnLocation.set_offset(randi())
	
	#Instance mob 
	var mob = Mob.instance()
	add_child(mob)
	
	#spawn mob in correct direction and location
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	direction += rand_range(-PI / 4, PI / 4)
	mob.position = $MobPath/MobSpawnLocation.position
	mob.rotation = direction
	
	# set random velocity
	mob.set_linear_velocity(Vector2(rand_range(mob.min_speed, mob.max_speed), 0).rotated(direction))

