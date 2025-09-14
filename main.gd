extends Node

@export var mob_scene: PackedScene

func _ready():
	$UserInterface/Retry.hide()

func _on_mob_timer_timeout():
	# หา Player สดใหม่ทุกครั้ง
	var player = get_node_or_null("Player")
	if not player or not is_instance_valid(player):
		print("⚠ ไม่มี Player (อาจตายไปแล้ว)")
		return

	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on the SpawnPath.
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	mob_spawn_location.progress_ratio = randf()

	# ใช้ตำแหน่ง Player ได้แล้ว
	var player_position = player.position
	mob.initialize(mob_spawn_location.position, player_position)

	# Spawn the mob
	add_child(mob)

	# Connect mob -> score
	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind())

func _on_player_hit():
	$MobTimer.stop()
	$UserInterface/Retry.show()

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		# รีโหลดทั้ง scene จะสร้าง Player ใหม่
		get_tree().reload_current_scene()
