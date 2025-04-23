extends Node3D


var isPlayer = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player.canBeControlled = true
	$spider2.canBeControlled = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isPlayer:
		$spider2.position = $Player.position
	
	if Input.is_action_just_pressed("switch_control"):
		isPlayer = !isPlayer
		if isPlayer:
			set_player_form()
		else : 
			set_spider_form()

func set_player_form():
	$spider2.visible = false
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
