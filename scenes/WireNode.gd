extends Sprite

var connector = null
var pair_node = null
var power_source = null

onready var area = $Area
onready var rising_pop = $RisingPop
onready var falling_pop = $FallingPop


func _ready():
	material = ShaderMaterial.new()
	material.shader = load("res://assets/shaders/Outline.gdshader")
	material.set_shader_param("line_color", Color.papayawhip)
	GameState.connect("drag", self, "_on_drag")
	GameState.connect("drag_to", self, "_on_drag_to")
	area.connect("mouse_entered", self, "_on_Area_mouse_entered")
	area.connect("mouse_exited", self, "_on_Area_mouse_exited")


func _physics_process(_delta):
	power_source = get_power_source([])
	_update_node_outlines()
	_update_node_colors()
	_update_debug_visual()


func get_power_source(found):
	if found.has(self):
		return null
	found.append(self)
	var paired_power_source = null
	var connected_power_source = null
	if pair_node != null and pair_node.has_method("get_power_source"):
		paired_power_source = pair_node.get_power_source(found)
	if connector != null and connector.has_method("get_power_source"):
		connected_power_source = connector.get_power_source(found)
	if paired_power_source != null or connected_power_source != null:
		if connected_power_source != null:
			return connected_power_source
		else:
			return paired_power_source
	return null


func _on_drag(object, _from, to):
	if object != self:
		return
	global_position = to
	if connector != null:
		connector.connection = null
		connector = null
		falling_pop.play()


func _on_drag_to(object, to):
	if object != self:
		return
	if to != null and not (to is WireConnector):
		return
	if to != null:
		global_position = to.global_position
		to.connection = self
		rising_pop.play()
	connector = to


func _on_Area_mouse_entered():
	if connector != null and connector.locked:
		return
	GameState.hovered_object = self


func _on_Area_mouse_exited():
	if GameState.hovered_object == self:
		GameState.hovered_object = null


func _update_node_outlines():
	if GameState.hovered_object == self or GameState.held_object == self:
		material.set_shader_param("line_thickness", 1.0)
	else:
		material.set_shader_param("line_thickness", 0.0)


func _update_node_colors():
	if connector != null and connector.locked:
		frame = 1
	else:
		frame = 0


func _update_debug_visual():
	if power_source != null:
		modulate = Color.green
	else:
		modulate = Color.white
