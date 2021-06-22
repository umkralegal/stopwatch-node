# Made by UmKraLegal

# Based on original timer.cpp file (MIT license)
# https://github.com/godotengine/godot/blob/8b692e88726bb7ab114a3a0b1b2ffd973dd4f054/scene/main/timer.cpp

# Stopwatch icon by svgrepo.com (CC0 license)
# https://www.svgrepo.com/svg/22815/stopwatch

class_name Stopwatch, "stopwatch.svg"
extends Node


signal tick(time)

enum StopwatchProcessMode {
	STOPWATCH_PROCESS_PHYSICS,
	STOPWATCH_PROCESS_IDLE,
}


export(int, "Physics", "Idle") var process_mode: int = StopwatchProcessMode.STOPWATCH_PROCESS_IDLE setget set_timer_process_mode, get_timer_process_mode
export(bool) var autostart: bool = false setget set_autostart, has_autostart
var paused: bool = false setget set_paused, is_paused
var elapsed_time: float = 0.0
var _processing: bool = false


func _notification(what) -> void:
	match what:
		NOTIFICATION_READY:
			if autostart:
				start()
				autostart = false

		NOTIFICATION_INTERNAL_PROCESS:
			if not _processing or process_mode == StopwatchProcessMode.STOPWATCH_PROCESS_PHYSICS or not is_processing_internal():
				return
			elapsed_time += get_process_delta_time()
			emit_signal("tick", elapsed_time)

		NOTIFICATION_INTERNAL_PHYSICS_PROCESS:
			if not _processing or process_mode == StopwatchProcessMode.STOPWATCH_PROCESS_IDLE or not is_physics_processing_internal():
				return
			elapsed_time += get_physics_process_delta_time()
			emit_signal("tick", elapsed_time)


func start() -> void:
	if not is_inside_tree():
		printerr("Stopwatch was not added to the SceneTree. Either add it or set autostart to true.")
	_set_process(true)


func stop() -> void:
	elapsed_time = 0.0
	_set_process(false)
	autostart = false


func set_paused(value: bool) -> void:
	if paused == value:
		return

	paused = value


func is_paused() -> bool:
	return paused


func is_stopped() -> bool:
	return get_elapsed_time() <= 0.0


func get_elapsed_time() -> float:
	return elapsed_time if elapsed_time >= 0.0 else 0.0


func set_timer_process_mode(value: int) -> void:
	if process_mode == value:
		return

	match process_mode:
		StopwatchProcessMode.STOPWATCH_PROCESS_PHYSICS:
			if is_physics_processing_internal():
				set_physics_process_internal(false)
				set_process_internal(true)

		StopwatchProcessMode.STOPWATCH_PROCESS_IDLE:
			if is_processing_internal():
				set_process_internal(false)
				set_physics_process_internal(true)

	process_mode = value


func _set_process(process: bool) -> void:
	match process_mode:
		StopwatchProcessMode.STOPWATCH_PROCESS_PHYSICS:
			set_physics_process_internal(process and not paused)

		StopwatchProcessMode.STOPWATCH_PROCESS_IDLE:
			set_process_internal(process and not paused)
	_processing = process


func get_timer_process_mode() -> int:
	return process_mode


func set_autostart(value: bool) -> void:
	autostart = value


func has_autostart() -> bool:
	return autostart
