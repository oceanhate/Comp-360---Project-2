extends VehicleBody3D

# References to the 2 sound players under this car
@onready var idle_sound  = $EngineIdle
@onready var accel_sound = $EngineAudio

# Basic car settings
const STEER := 0.4
const FORCE := 100.0
const SPEED_LIMIT := 0.25    # speed at which car counts as "moving"

# Audio time markers (in seconds) from the acceleration sound file
const START := 0.0
const LOOP_A := 6.0 
const LOOP_B := 8.0
const DECEL := 8.0

# State variables
var was_forward = false
var decel_playing = false

func _ready():
	# Start the idle sound right away (it loops forever)
	idle_sound.play()

func _physics_process(delta):
	# Get input: W = forward, S = back, A/D = steering
	var forward = Input.is_action_pressed("forward")
	steering = Input.get_axis("right", "left") * STEER
	engine_force = Input.get_axis("back", "forward") * FORCE
	var moving = linear_velocity.length() > SPEED_LIMIT

	# Idle sound 
	# Stop idle when car moves, play again when car is still
	if moving or forward:
		if idle_sound.playing:
			idle_sound.stop()
	else:
		if not idle_sound.playing:
			idle_sound.play()

	# Acceleration / deceleration control
	if forward:
		# Car just started moving: play acceleration start
		if not was_forward:
			accel_sound.play(START)
		# Keep looping the 6–8s range while holding W
		elif accel_sound.get_playback_position() >= LOOP_B:
			accel_sound.play(LOOP_A)
	elif was_forward:
		# Released W: play the deceleration part once
		accel_sound.play(DECEL)
		decel_playing = true

	# When deceleration finishes, mark it as done
	if decel_playing and not accel_sound.playing:
		decel_playing = false

	# Save current input state for next frame
	was_forward = forward
