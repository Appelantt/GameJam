extends Node3D


var isPlayer = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player.canBeControlled = true
	$spider2.canBeControlled = false

func update_spider_position():
	var forward = $Player.global_transform.basis.z
	var right = $Player.global_transform.basis.x
	var offset = forward * 1.2 + right * 0.5  # Derrière (2 unités) + à droite (1 unité)
	$spider2.global_position = $Player.global_position + offset

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isPlayer:
		update_spider_position()
	
	if Input.is_action_just_pressed("switch_control"):
		isPlayer = !isPlayer
		if isPlayer:
			set_player_form()
		else : 
			set_spider_form()

func set_player_form():
	$spider2.visible = true
	$Player.visible = true
	$spider2.canBeControlled = false
	$Player.canBeControlled = true
	$Player.set_camera_visibility(true)
	$spider2.set_camera_visibility(false)
	
func set_spider_form():
	$spider2.visible = true
	$Player.visible = true
	$spider2.canBeControlled = true
	$Player.canBeControlled = false
	$Player.set_camera_visibility(false)
	$spider2.set_camera_visibility(true)
