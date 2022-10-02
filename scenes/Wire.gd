class_name Wire extends Node2D

const wire_stiffness = 50.0

export var init_connection_a: NodePath
export var init_connection_b: NodePath

var power_source = null
var powered = false
var silent = true

var wire_direction_a = Vector2.RIGHT
var wire_direction_b = Vector2.LEFT

onready var line = $Line
onready var node_a = $NodeA
onready var node_b = $NodeB
onready var rising_pop = $RisingPop
onready var falling_pop = $FallingPop


func _ready():
	node_a.pair_node = node_b
	node_b.pair_node = node_a
	yield(get_tree(), "idle_frame")
	_init_connect(node_a, init_connection_a)
	_init_connect(node_b, init_connection_b)
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	silent = false


func _physics_process(_delta):
	_update_wire_directions()
	_update_wire()


func _update_wire_directions():
	var angle_a_to_b = (node_b.position - node_a.position).angle()
	wire_direction_a = Vector2.RIGHT.rotated(angle_a_to_b - (PI / 2))
	wire_direction_b = -wire_direction_a
	if node_a.connector != null:
		wire_direction_a = Vector2.RIGHT.rotated(node_a.connector.rotation)
	if node_b.connector != null:
		wire_direction_b = Vector2.RIGHT.rotated(node_b.connector.rotation)


func _update_wire():
	var curve = Curve2D.new()
	curve.add_point(node_a.position, Vector2.ZERO, wire_direction_a * wire_stiffness)
	curve.add_point(node_b.position, wire_direction_b * wire_stiffness, Vector2.ZERO)
	line.points = curve.get_baked_points()


func _init_connect(wire_end, node_path):
	if node_path == null or not has_node(node_path):
		return
	var node = get_node(node_path)
	wire_end._on_drag_to(wire_end, node, true)
