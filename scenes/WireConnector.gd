class_name WireConnector extends Node2D

export var locked: bool
export var module: NodePath

var connection = null
var module_node = null
var power_source = null

onready var sprite = $Sprite
onready var click_area = $Sprite/Area2D
onready var lock = $Lock


func _ready():
	sprite.material = ShaderMaterial.new()
	sprite.material.shader = load("res://assets/shaders/Outline.gdshader")
	sprite.material.set_shader_param("line_color", Color.papayawhip)
	lock.modulate = Color.white#lightcoral
	if module != null and has_node(module):
		module_node = get_node(module)
	click_area.connect("mouse_entered", self, "_on_Area2D_mouse_entered")
	click_area.connect("mouse_exited", self, "_on_Area2D_mouse_exited")


func _physics_process(_delta):
	if GameState.hovered_object == self or GameState.held_object == self:
		sprite.material.set_shader_param("line_thickness", 1.0)
	else:
		sprite.material.set_shader_param("line_thickness", 0.0)
	click_area.input_pickable = !locked
	lock.visible = locked
	power_source = get_power_source([])
	_update_debug_visual()


func get_power_source(found):
	if found.has(self):
		return null
	found.append(self)
	var module_power_source = null
	var connected_power_source = null
	if module_node != null and module_node.has_method("get_power_source"):
		module_power_source = module_node.get_power_source(found)
	if connection != null and connection.has_method("get_power_source"):
		connected_power_source = connection.get_power_source(found)
	if module_power_source != null or connected_power_source != null:
		if module_power_source != null:
			return module_power_source
		else:
			return connected_power_source
	return null


func _update_debug_visual():
	if not GameState.debug:
		return
	if power_source != null:
		modulate = Color.green
	else:
		modulate = Color.white


func _on_Area2D_mouse_entered():
	if connection != null:
		return
	GameState.hovered_object = self


func _on_Area2D_mouse_exited():
	if GameState.hovered_object == self:
		GameState.hovered_object = null
