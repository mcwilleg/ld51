class_name Wire extends Node2D

const wire_stiffness = 50.0

export var init_connection_a: NodePath
export var init_connection_b: NodePath

var connection_a = null
var connection_b = null
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
	node_a.material = ShaderMaterial.new()
	node_a.material.shader = load("res://assets/shaders/Outline.gdshader")
	node_a.material.set_shader_param("line_color", Color.papayawhip)
	node_b.material = ShaderMaterial.new()
	node_b.material.shader = load("res://assets/shaders/Outline.gdshader")
	node_b.material.set_shader_param("line_color", Color.papayawhip)
	GameState.connect("drag", self, "_on_drag")
	GameState.connect("drag_to", self, "_on_drag_to")
	yield(get_tree(), "idle_frame")
	_init_connect(node_a, init_connection_a)
	_init_connect(node_b, init_connection_b)
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	silent = false


func _physics_process(_delta):
	_update_node_outlines()
	_update_node_colors()
	_update_wire_directions()
	_update_wire()
	_update_powered()


func _update_powered():
	if connection_a != null and connection_a.powered:
		powered = true
	elif connection_b != null and connection_b.powered:
		powered = true
	else:
		powered = false


func _update_node_outlines():
	if GameState.hovered_object == node_a or GameState.held_object == node_a:
		node_a.material.set_shader_param("line_thickness", 1.0)
	else:
		node_a.material.set_shader_param("line_thickness", 0.0)
	if GameState.hovered_object == node_b or GameState.held_object == node_b:
		node_b.material.set_shader_param("line_thickness", 1.0)
	else:
		node_b.material.set_shader_param("line_thickness", 0.0)


func _update_node_colors():
	if connection_a != null and connection_a.locked:
		#node_a.modulate = Color.white#lightcoral
		node_a.frame = 1
	else:
		#node_a.modulate = Color.white
		node_a.frame = 0
	if connection_b != null and connection_b.locked:
		#node_b.modulate = Color.white#lightcoral
		node_b.frame = 1
	else:
		#node_b.modulate = Color.white
		node_b.frame = 0


func _update_wire_directions():
	var angle_a_to_b = (node_b.position - node_a.position).angle()
	wire_direction_a = Vector2.RIGHT.rotated(angle_a_to_b - (PI / 2))
	wire_direction_b = -wire_direction_a
	if connection_a != null:
		wire_direction_a = Vector2.RIGHT.rotated(connection_a.rotation)
	if connection_b != null:
		wire_direction_b = Vector2.RIGHT.rotated(connection_b.rotation)


func _update_wire():
	var curve = Curve2D.new()
	curve.add_point(node_a.position, Vector2.ZERO, wire_direction_a * wire_stiffness)
	curve.add_point(node_b.position, wire_direction_b * wire_stiffness, Vector2.ZERO)
	line.points = curve.get_baked_points()


func _on_drag(object, _from, to):
	if object == node_a:
		node_a.global_position = to
		if connection_a != null:
			connection_a.connection = null
			connection_a = null
			if not silent:
				falling_pop.play()
	if object == node_b:
		node_b.global_position = to
		if connection_b != null:
			connection_b.connection = null
			connection_b = null
			if not silent:
				falling_pop.play()


func _on_drag_to(object, to):
	if to != null and not (to is WireConnector):
		return
	if object == node_a:
		if to != null:
			node_a.global_position = to.global_position
			to.connection = self
			if not silent:
				rising_pop.play()
		connection_a = to
	if object == node_b:
		if to != null:
			node_b.global_position = to.global_position
			to.connection = self
			if not silent:
				rising_pop.play()
		connection_b = to


func _init_connect(wire_end, node_path):
	if node_path == null or not has_node(node_path):
		return
	var node = get_node(node_path)
	_on_drag_to(wire_end, node)


func _on_AreaA_mouse_entered():
	if connection_a != null and connection_a.locked:
		return
	GameState.hovered_object = node_a


func _on_AreaA_mouse_exited():
	if GameState.hovered_object == node_a:
		GameState.hovered_object = null


func _on_AreaB_mouse_entered():
	if connection_b != null and connection_b.locked:
		return
	GameState.hovered_object = node_b


func _on_AreaB_mouse_exited():
	if GameState.hovered_object == node_b:
		GameState.hovered_object = null
