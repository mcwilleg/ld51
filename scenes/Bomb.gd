class_name Bomb extends Node2D

var wire_scene = preload("res://scenes/Wire.tscn")


func start_timer():
	if has_node("BombClock"):
		get_node("BombClock").start_timer()


func add_wire(from, to):
	if from == null or to == null or not has_node(from) or not has_node(to):
		return
	var from_path = get_node(from).get_path()
	var to_path = get_node(to).get_path()
	var wire = wire_scene.instance()
	wire.init_connection_a = from_path
	wire.init_connection_b = to_path
	add_child(wire)
