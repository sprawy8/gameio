extends Node2D

var troops = 0
var owner_id = -1
var target = null
var speed = 200  # pixels per second

func setup(_troops, _owner_id, _target):
	troops = _troops
	owner_id = _owner_id
	target = _target

func _process(delta):
	if target == null:
		queue_free()
		return

	var direction = (target.global_position - global_position).normalized()
	var distance = speed * delta

	if global_position.distance_to(target.global_position) <= distance:
		# Arrived at target
		_resolve_battle()
		queue_free()
	else:
		global_position += direction * distance

func _resolve_battle():
	if target.owner_id == owner_id:
		# Reinforce friendly territory
		target.troop_count += troops
	else:
		if troops > target.troop_count:
			var remaining = troops - target.troop_count
			target.assign_owner(owner_id, get_player_color(owner_id))
			target.troop_count = remaining
		else:
			target.troop_count -= troops
			if target.troop_count < 0:
				target.troop_count = 0
	target.update_display()

func get_player_color(id):
	var colors = [Color.RED, Color.BLUE, Color.GREEN]
	return colors[id % colors.size()]
