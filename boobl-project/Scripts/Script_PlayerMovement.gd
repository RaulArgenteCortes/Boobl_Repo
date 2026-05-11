extends CharacterBody2D


const speed = 65
const jumpForce = -130
const dashForce = 135
const stickedSpeed = speed * 0.7
const stickedJumpForce = jumpForce * 0.7
const stickedDashForce = dashForce * 0.7
var inputDirection = Vector2.ZERO
var facingDirection = Vector2(1, 1)
var onGround = false
var falling = false
var canDash = false
var canJump = false
var isDying = false
var isLanding = false
var isDashing = false
var stickN = false
var stickS = false
var stickW = false
var stickE = false
var isSticked = false

@onready var spawnPlayer = $"../SpawnPlayer"
@onready var bubbleFollow = $BubbleFollow
@onready var bubbleSide = bubbleFollow.position
@onready var animated_sprite = $AnimatedSprite2D


func _ready() -> void:
	position = spawnPlayer.position

func _physics_process(delta: float) -> void:
	
	_handle_stick()
	
	if !isDying:
		_apply_gravity(delta)
		if !isSticked:
			_handle_movement()
			_handle_jump()
		else:
			_handle_sticky_movement()
			_handle_sticky_jump()
	else:
		_freeze()
	
	_handle_direction()
	#_handle_reset() # Disabled.
	
	move_and_slide()

func _process(_delta: float) -> void:
	
	_handle_animations()

#region Update Functions
func _apply_gravity(delta):
	
	if !is_on_floor() && !isDashing && !isSticked:
		if velocity.y < -jumpForce: # Limits the falling speed.
			velocity += (get_gravity()/4) * delta

func _handle_stick():
	if (stickN || stickS || stickW || stickE):
		if !isSticked:
			isSticked = true
			# Animation stuff:
			isLanding = true
			animated_sprite.play("Landing")
	if !(stickN || stickS || stickW || stickE):
		if isSticked:
			isSticked = false
			# Animation stuff:
			isLanding = false

func _handle_direction():
	
	inputDirection = Vector2(Input.get_axis("gameplay_left", "gameplay_right"), Input.get_axis("gameplay_up", "gameplay_down"))
	
	if !isDashing:
		if inputDirection.x > 0.7:
			facingDirection.x = 1
		elif inputDirection.x < -0.7:
			facingDirection.x = -1
	
	if isSticked:
		if inputDirection.y > 0.7:
			facingDirection.y = 1
		elif inputDirection.y < -0.7:
			facingDirection.y = -1
	else:
		if velocity.y > 0:
			facingDirection.y = 1
		elif velocity.y < -0:
			facingDirection.y = -1

func _handle_movement():
	
	if !isDashing:
		if abs(inputDirection.x) > 0.7:
			velocity.x = speed * facingDirection.x
		else:
			velocity.x = 0
	
	if isDashing && is_on_wall():
		await get_tree().create_timer(0.02).timeout # Fixes some interactions.
		if isDashing && is_on_wall():
			isDashing = false

func _handle_jump():
	
	if is_on_floor():
		canJump = true
		canDash = true
	
	if Input.is_action_just_pressed("gameplay_jump"):
		if onGround && canJump:
			canJump = false
			velocity.y = jumpForce
		elif !onGround && !isDashing && canDash:
			_on_dash()

func _handle_sticky_movement():
	
	if !isDashing:
		if abs(inputDirection.x) > 0.7:
			velocity.x = stickedSpeed * facingDirection.x
		else:
			velocity.x = 0
		if (stickW || stickE || stickN):
			if abs(inputDirection.y) > 0.7:
				velocity.y = stickedSpeed * facingDirection.y
			else:
				velocity.y = 0

func _handle_sticky_jump():
	
	if Input.is_action_just_pressed("gameplay_jump"):
		canJump = false
		isSticked = false
		if stickS:
			position.y += -1
			velocity.y = stickedJumpForce
		elif stickN:
			position.y += 1
		else:
			_on_sticky_dash()

func _freeze():
	velocity = Vector2.ZERO

func _handle_reset():
	if Input.is_action_just_pressed("gameplay_reset"):
		_on_death()
#endregion

#region Trigger Functions
func _on_area_entered_groundcheck(_body: Node2D) -> void:
	onGround = true
func _on_area_exited_groundcheck(_body: Node2D) -> void:
	onGround = false

func _on_area_entered_death(_body: Node2D) -> void:
	_on_death()

func _on_dash():
	
	isDashing = true
	velocity = Vector2.ZERO
	canDash = false
	
	await get_tree().create_timer(0.01).timeout
	velocity.x += dashForce * facingDirection.x
	await get_tree().create_timer(0.45).timeout
	
	if isDashing:
		isDashing = false
		velocity = Vector2.ZERO

func _on_sticky_dash():
	
	facingDirection.x *= -1
	isDashing = true
	velocity = Vector2.ZERO
	
	await get_tree().create_timer(0.01).timeout
	position.x += 2 * facingDirection.x
	velocity.x += stickedDashForce * facingDirection.x
	await get_tree().create_timer(0.175).timeout
	
	if isDashing:
		isDashing = false
		velocity = Vector2.ZERO

func _on_death():
	isDying = true
	canDash = false
#endregion

#region Trigger Sticky Functions
func _on_area_entered_sticky_N(_body: Node2D) -> void:
	stickN = true
	if stickW: # Fixes a small interaction.
		facingDirection.x = 1
	if stickE: # Fixes a small interaction.
		facingDirection.x = -1
func _on_area_exited_sticky_N(_body: Node2D) -> void: stickN = false

func _on_area_entered_sticky_S(_body: Node2D) -> void: stickS = true
func _on_area_exited_sticky_S(_body: Node2D) -> void: stickS = false

func _on_area_entered_sticky_W(_body: Node2D) -> void:
	stickW = true
	if isSticked: # Fixes a small interaction.
		facingDirection.y = -1
func _on_area_exited_sticky_W(_body: Node2D) -> void: stickW = false

func _on_area_entered_sticky_E(_body: Node2D) -> void:
	stickE = true
	if isSticked: # Fixes a small interaction.
		facingDirection.y = -1
func _on_area_exited_sticky_E(_body: Node2D) -> void: stickE = false
#endregion

#region Animation Functions
func _handle_animations():
	
	animated_sprite.flip_h = (facingDirection.x == -1)
	
	if isSticked:
		if stickN:
			animated_sprite.position = Vector2(0, 1)
			animated_sprite.flip_v = true
			animated_sprite.rotation_degrees = 0
			bubbleFollow.position.x = bubbleSide.x * facingDirection.x
			bubbleFollow.position.y = bubbleSide.y * -1
		elif stickW:
			animated_sprite.position = Vector2(1, 0)
			animated_sprite.flip_v = false
			animated_sprite.flip_h = (facingDirection.y == -1)
			animated_sprite.rotation_degrees = 90
			bubbleFollow.position.x = bubbleSide.y * -1
			bubbleFollow.position.y = bubbleSide.x * facingDirection.y
		elif stickE:
			animated_sprite.position = Vector2(-1, 0)
			animated_sprite.flip_v = false
			animated_sprite.flip_h = (facingDirection.y == 1)
			animated_sprite.rotation_degrees = -90
			bubbleFollow.position.x = bubbleSide.y * 1
			bubbleFollow.position.y = bubbleSide.x * facingDirection.y
		elif stickS:
			animated_sprite.position = Vector2(0, -1)
			animated_sprite.flip_v = false
			animated_sprite.rotation_degrees = 0
			bubbleFollow.position.x = bubbleSide.x * facingDirection.x
			bubbleFollow.position.y = bubbleSide.y
	else:
		animated_sprite.position = Vector2(0, -1)
		animated_sprite.flip_v = false
		animated_sprite.rotation_degrees = 0
		bubbleFollow.position.x = bubbleSide.x * facingDirection.x
		bubbleFollow.position.y = bubbleSide.y
	
	if isDying:
			animated_sprite.play("Death")
	elif !isSticked:
		if !isDashing && !isLanding:
			if velocity.y == 0 && is_on_floor():
				if abs(inputDirection.x) <= 0.7:
					animated_sprite.play("Idle")
				else:
					animated_sprite.play("Walk")
			else:
				if velocity.y <= 0:
					animated_sprite.play("Jump_Up")
				else:
					animated_sprite.play("Jump_Down")
		elif !isLanding:
			animated_sprite.play("Dash")
	else:
		if !isLanding:
			if abs(inputDirection.x) >= 0.7 || abs(inputDirection.y) >= 0.7:
				animated_sprite.play("Walk_Sticked")
			else:
				animated_sprite.play("Idle_Sticked")
	
	if is_on_floor() && falling:
		falling = false
		isLanding = true
		animated_sprite.play("Landing")
	elif !is_on_floor() && velocity.y > 0:
		falling = true

func _animation_finished() -> void:
	if animated_sprite.animation == "Landing":
		isLanding = false
	if animated_sprite.animation == "Death":
		isDying = false
		velocity = Vector2.ZERO
		position = spawnPlayer.position
		animated_sprite.play("Jump_Down")
#endregion
