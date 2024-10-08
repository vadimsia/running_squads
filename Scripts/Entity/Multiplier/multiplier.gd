class_name Multiplier extends Entity

const STRONG_COEF = 1.5

@onready var health_label: Label3D = $HealthLabel
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var player_squad: PlayerSquad = get_node("/root/Main/PlayerPool")

@export var health_range = 40


func get_multiplier() -> int:
	var first_player = player_squad.get_alive_player()
	if not first_player:
		return 0
	

	return -health / (first_player.health * player_squad.get_child_count() * STRONG_COEF)


func _ready() -> void:
	health = randi_range(-health_range, health_range)
	health_changed.connect(_on_health_changed)
	body_entered.connect(_on_multiplier_body_entered)
	super._ready()
	health_label.text = "?"


func _on_multiplier_body_entered(body: Node) -> void:
	if body is not Player:
		return

	queue_free()
	
	var multiplier = get_multiplier()
	if multiplier > 0:
		player_squad.spawn_players(multiplier)
	elif multiplier < 0:
		player_squad.remove_players(abs(multiplier))



func _on_health_changed(_old_value: int, _new_value: int) -> void:
	var material: Material = mesh.get_active_material(0)
	if get_multiplier() < 0:
		material.albedo_color = Color8(200, 75, 85, 125)
	else:
		material.albedo_color = Color8(70, 120, 215, 125)

	health_label.text = str(get_multiplier())
