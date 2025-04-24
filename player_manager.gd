extends Node3D


var isPlayer = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player.canBeControlled = true
	$spider2.canBeControlled = false
	
	

func update_spider_position():
	var player_pos = $Player.global_position
	var offset = Vector3(0.5, 0, 1.2)  # Un peu à droite (x), et derrière (z)
	$spider2.global_position = player_pos + offset
	$spider2.rotation = Vector3(0, 0, 0)


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


func _on_area_3d_body_exited(body: Node3D) -> void:
	pass # Replace with function body.
