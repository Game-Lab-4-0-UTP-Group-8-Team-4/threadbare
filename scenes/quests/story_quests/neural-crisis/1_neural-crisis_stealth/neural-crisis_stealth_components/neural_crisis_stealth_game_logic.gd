# StealthGameLogic.gd

# SPDX-FileCopyrightText: The Threadbare Authors
# SPDX-License-Identifier: MPL-2.0
@tool

extends Node

@export_range(0.5, 3.0, 0.1, "or_greater", "or_less") var zoom: float = 1.0:
	set = _set_zoom

# ¡CAMBIO 1! Cambiamos el tipo de TileMap a TileMapLayer.
@export var map_layer: TileMapLayer


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	_set_zoom(zoom)
	_set_camera_limits()

	for guard: Guard in get_tree().get_nodes_in_group(&"guard_enemy"):
		guard.player_detected.connect(self._on_player_detected)


func _set_camera_limits() -> void:
	# ¡CAMBIO 2! Comprobamos si 'map_layer' fue asignado.
	if not map_layer:
		print("ADVERTENCIA: No se asignó un TileMapLayer a StealthGameLogic.")
		return
		
	var camera: Camera2D = get_viewport().get_camera_2d()
	if not camera:
		return

	await get_tree().physics_frame
	
	# ¡CAMBIO 3! Usamos 'map_layer' para obtener el rectángulo y el tile_set.
	# El nodo TileMapLayer también tiene estos métodos y propiedades.
	var map_rect = map_layer.get_used_rect()
	var cell_size = map_layer.tile_set.tile_size
	
	camera.limit_left = map_rect.position.x * cell_size.x
	camera.limit_top = map_rect.position.y * cell_size.y
	camera.limit_right = map_rect.end.x * cell_size.x
	camera.limit_bottom = map_rect.end.y * cell_size.y


func _on_player_detected(detected_node: Node2D) -> void:
	if detected_node is Player:
		var player_instance: Player = detected_node
		player_instance.mode = Player.Mode.DEFEATED
		await get_tree().create_timer(2.0).timeout
		SceneSwitcher.reload_with_transition(Transition.Effect.FADE, Transition.Effect.FADE)


func _set_zoom(new_value: float) -> void:
	zoom = new_value
	if Engine.is_editor_hint():
		return
	if not is_node_ready():
		return
	var camera: Camera2D = get_viewport().get_camera_2d()
	if camera:
		camera.zoom = Vector2.ONE * zoom
