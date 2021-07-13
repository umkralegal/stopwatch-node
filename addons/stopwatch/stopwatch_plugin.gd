tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("Stopwatch", "Node", preload("res://addons/stopwatch/stopwatch.gd"), preload("res://addons/stopwatch/stopwatch.png"))


func _exit_tree():
	remove_custom_type("Stopwatch")
