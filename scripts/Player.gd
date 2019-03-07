extends Area2D

# Signals
signal hit

# Globals
var screensize
var vj_center #center of our virtual joystick (for mouse & touch input) - if null no input
var vj_direction #current direction of the virtual joystick

# Properties
export (int) var speed # Speed of player in px/s

func _ready():
	hide()
	screensize = get_viewport_rect().size

func _process(delta):
	var velocity = Vector2()
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	
	if vj_direction != null:
		velocity = vj_direction
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.is_pressed():
				vj_center = event.position
			else:
				vj_center = null
				vj_direction = null
	elif vj_center != null && event is InputEventMouseMotion:
		vj_direction = event.position - vj_center

func _on_Player_body_entered(body):
	hide()
	emit_signal("hit")
	$CollisionShape2D.disabled = true
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
