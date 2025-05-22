extends Node2D

@onready var territories := []
@onready var troop_slider := $CanvasLayer/PlayerUI/Player0Slider
@onready var slider_label := $CanvasLayer/PlayerUI/SliderLabel

#Growth of troops
var growth_interval = 1.0 # seconds
var growth_amount = 5

func _ready():
	territories = get_tree().get_nodes_in_group("territories")
	assign_initial_owners()
	
	troop_slider.connect("value_changed", Callable(self, "_on_slider_value_changed"))
	_on_slider_value_changed(troop_slider.value) # update label initially
	
	var timer = Timer.new()
	timer.wait_time = growth_interval
	timer.one_shot = false
	timer.autostart = true
	add_child(timer)
	timer.connect("timeout", Callable(self, "_on_growth_timer_timeout"))

func _on_slider_value_changed(value):
	slider_label.text = "Send: " + str(value) + "%"
	
func _on_growth_timer_timeout():
	for territory in get_tree().get_nodes_in_group("territories"):
		territory.troop_count += growth_amount
		territory.update_display()
		

var selected_source = null
var selected_territory = null

func on_territory_clicked(territory):
	if selected_source == null:
	# Select source territory owned by current player (assume player 0 for now)
	# Changed for tests so that its possible to try each territory.
		if territory.owner_id == 0 || territory.owner_id == 1 || territory.owner_id == 2:
			selected_source = territory
			territory.set_selected(true)
			print("Source selected: ", territory.owner_id)
		else:
			print("Select your own territory first")
	else:
		# Target selected
		if territory == selected_source:
			# Deselect source if clicked again
			selected_source.set_selected(false)
			selected_source = null
			print("Source deselected")
		else:
			# Send troops from source to target
			print("Sending troops from ", selected_source.owner_id, " to territory ", territory.owner_id)
			send_troops(selected_source, territory)
			selected_source.set_selected(false)
			selected_source = null

func send_troops(source, target):
	var send_percent = troop_slider.value / 100.0
	var troops_to_send = int(source.troop_count * send_percent)
	if troops_to_send == 0:
		print("Not enough troops to send")
		return
	source.troop_count -= troops_to_send
	source.update_display()

	var troop_move_scene = preload("res://scenes/TroopMovement.tscn")
	var troop_move = troop_move_scene.instantiate()
	troop_move.global_position = source.global_position
	troop_move.setup(troops_to_send, source.owner_id, target)
	add_child(troop_move)


func assign_initial_owners():
	var player_colors = [
		Color.RED,
		Color.BLUE,
		Color.GREEN,
	]

	for i in range(min(territories.size(), player_colors.size())):
		territories[i].assign_owner(i, player_colors[i])
		#territories[i].troop_count = randi_range(20, 50)
		territories[i].troop_count = 50
		territories[i].update_display()
