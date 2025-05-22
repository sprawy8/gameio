extends Area2D

@export var owner_id: int = -1
@export var troop_count: int = 0

@export var territory_id: int = -1
#@export var neighbor_ids: Array[int] = []
@export var neighbor_ids := []

var default_color = Color(0.8, 0.8, 0.8)
var selected_color = Color(1, 1, 0)
var is_selected: bool = false


@onready var poly = $Polygon2D
@onready var label = $Label
@onready var collision: CollisionPolygon2D = $CollisionPolygon2D

func _init():
	neighbor_ids = []

func _ready():
	# Make sure the territory is in the group, so Map.gd finds it
	add_to_group("territories")
	print("territory_id:", territory_id, "neighbor_ids:", neighbor_ids)
	#collision.input_pickable = true
	# Give it a default color for testing (will be overwritten later)
	#$Polygon2D.color = Color.RED	
	update_display()

func update_display():
	#Highlight selected
	#poly.color = selected_color if is_selected else default_color
	#poly.color = default_color
	#label.text = str(troop_count)
	label.text = str(troop_count) + "\nID: " + str(territory_id)

func assign_owner(id: int, color: Color):
	owner_id = id
	print("Assigning color to territory:", color)
	poly.color = color


func set_selected(selected: bool):
	is_selected = selected
	update_display()


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		get_parent().on_territory_clicked(self)
