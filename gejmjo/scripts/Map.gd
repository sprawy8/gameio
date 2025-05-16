extends Node2D

@onready var territories := []

func _ready():
	territories = get_tree().get_nodes_in_group("territories")
	assign_initial_owners()

func assign_initial_owners():
	var player_colors = [
		Color.RED,
		Color.BLUE,
		Color.GREEN,
	]

	for i in range(min(territories.size(), player_colors.size())):
		territories[i].assign_owner(i, player_colors[i])
		territories[i].troop_count = randi_range(20, 50)
		territories[i].update_display()
