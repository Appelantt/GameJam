extends Node3D

var isPlayer = true
var is_spider_attached = false

func _ready() -> void:
	$Player.canBeControlled = true
	$spider2.canBeControlled = false
	is_spider_attached = true
	update_spider_position()

func stop_spider():
	$spider2.velocity = Vector3.ZERO

func update_spider_position():
	var player_pos = $Player.global_position
	var player_forward = $Player.global_transform.basis.z.normalized()
	var player_right = $Player.global_transform.basis.x.normalized()
	var player_up = $Player.global_transform.basis.y.normalized()

	var offset = player_right * 2.0 + player_forward * -0.7 + player_up * 5.0
	$spider2.global_position = player_pos + offset

	$spider2.global_position = $Player/Mesh/Skeleton3D/SPIDER_POS.global_position + player_up * 1.25
	$spider2.rotation = $Player/Mesh/Skeleton3D/SPIDER_POS.global_rotation

func _process(delta: float) -> void:
	if isPlayer and is_spider_attached:
		update_spider_position()

	if Input.is_action_just_pressed("switch_control"):
		isPlayer = !isPlayer
		if isPlayer:
			set_player_form()
			stop_spider()
			is_spider_attached = false
		else: 
			set_spider_form()
			is_spider_attached = true

	if Input.is_action_just_pressed("recall_spider"):
		if isPlayer:
			is_spider_attached = true

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

func on_player_died():
	isPlayer = true
	$Player.visible = false
	$Player.canBeControlled = false
	$Player.set_camera_visibility(false)
	print("Le joueur est mort.")

func _on_area_3d_body_exited(body: Node3D) -> void:
	pass
