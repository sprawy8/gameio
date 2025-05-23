extends Area2D

@export var owner_id: int = -1
@export var troop_count: int = 0
@export var territory_id: int = -1
#@export var neighbor_ids: Array[int] = []
@export var neighbor_ids := [] # should be int but causes issues

var default_color = Color(0.8, 0.8, 0.8)
var selected_color = Color(1, 1, 0)
var is_selected: bool = false


@onready var poly = $Polygon2D
@onready var label = $Label
@onready var collision: CollisionPolygon2D = $CollisionPolygon2D

const EXPANSION_THRESHOLD = 100
const EXPANSION_SCENE = preload("res://scenes/ExpansionArea.tscn")

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

func _process(_delta):
	if troop_count > EXPANSION_THRESHOLD:
		#troop_count -= 100  # Cost of expansion
		spawn_expansion_area()
		troop_count -= 100

func spawn_expansion_area():
	var expansion = EXPANSION_SCENE.instantiate()
	#expansion.global_position = global_position
	expansion.global_position = global_position  # Keep global for now
	expansion.position = Vector2.ZERO  # Reset local offset in case it's non-zero
	expansion.owner_id = owner_id
	expansion.parent_territory = self
	expansion.connect("area_entered", Callable(self, "_on_expansion_area_entered"))
	get_tree().current_scene.add_child(expansion)
	scale_polygon_around_center(1.3)

		#poly.scale *= 1.05  # Increase size by 5% each time
	#var scaled_polygon := PackedVector2Array()
	#for point in poly.polygon:
	#	scaled_polygon.append(point * 1.05)
	#poly.polygon = scaled_polygon

func scale_polygon_around_center(scale_factor: float):
	var points = poly.polygon
	var center = Vector2.ZERO
	for point in points:
		center += point
	center /= points.size()

	var scaled = PackedVector2Array()
	for point in points:
		var offset = point - center
		scaled.append(center + offset * scale_factor)

	poly.polygon = scaled

	
func _on_expansion_area_entered(other_territory):
	if other_territory == self:
		return
	if other_territory.has_method("get_owner_id"):
		var other_id = other_territory.territory_id
		if not neighbor_ids.has(other_id):
			neighbor_ids.append(other_id)
			print("Territory %d added neighbor %d" % [territory_id, other_id])
			
func add_neighbor(id: int):
	if id != territory_id and not neighbor_ids.has(id):
		neighbor_ids.append(id)

func get_owner_id():
	return owner_id
	
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		get_parent().on_territory_clicked(self)
