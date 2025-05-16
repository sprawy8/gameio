extends Area2D

@export var owner_id: int = -1
@export var troop_count: int = 0

var default_color = Color(0.8, 0.8, 0.8)
var selected_color = Color(1, 1, 0)

@onready var poly = $Polygon2D
@onready var label = $Label

func _ready():
	# Make sure the territory is in the group, so Map.gd finds it
	add_to_group("territories")

	# Give it a default color for testing (will be overwritten later)
	$Polygon2D.color = Color.RED
	
	update_display()

func update_display():
	#poly.color = default_color
	label.text = str(troop_count)

func assign_owner(id: int, color: Color):
	owner_id = id
	print("Assigning color to territory:", color)
	poly.color = color


func set_selected(selected: bool):
	poly.color = selected_color if selected else default_color
