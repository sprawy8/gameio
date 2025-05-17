extends Node2D

@onready var territories := []
var selected_territory = null

#Growth of troops
var growth_interval = 1.0 # seconds
var growth_amount = 1

func _ready():
	territories = get_tree().get_nodes_in_group("territories")
	assign_initial_owners()
	var timer = Timer.new()
	timer.wait_time = growth_interval
	timer.one_shot = false
	timer.autostart = true
	add_child(timer)
	timer.connect("timeout", Callable(self, "_on_growth_timer_timeout"))

func _on_growth_timer_timeout():
	for territory in get_tree().get_nodes_in_group("territories"):
		territory.troop_count += growth_amount
		territory.update_display()
		
func on_territory_clicked(territory):
	if selected_territory:
		selected_territory.set_selected(false)

	selected_territory = territory
	selected_territory.set_selected(true)

	print("Selected territory with owner:", selected_territory.owner_id)

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
