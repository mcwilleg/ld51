class_name WireConnector extends Node2D

export var locked: bool
export var module: NodePath

var connection = null
var powered = false

onready var sprite = $Sprite
onready var click_area = $Sprite/Area2D
onready var lock = $Lock


func _ready():
	sprite.material = ShaderMaterial.new()
	sprite.material.shader = load("res://assets/shaders/Outline.gdshader")
	sprite.material.set_shader_param("line_color", Color.papayawhip)
	lock.modulate = Color.lightcoral


func _physics_process(_delta):
	if GameState.hovered_object == self or GameState.held_object == self:
		sprite.material.set_shader_param("line_thickness", 1.0)
	else:
		sprite.material.set_shader_param("line_thickness", 0.0)
	click_area.input_pickable = !locked
	lock.visible = locked


func power():
	if powered:
		return
	powered = true
	if connection != null and connection.has_method("power"):
		connection.power()
	if module != null and has_node(module):
		var module_node = get_node(module)
		if module_node != null and module_node.has_method("power"):
			module_node.power()


func _on_Area2D_mouse_entered():
	if connection != null:
		return
	GameState.hovered_object = self


func _on_Area2D_mouse_exited():
	if GameState.hovered_object == self:
		GameState.hovered_object = null
