@tool
extends Node

@export var first_string: String
@export var second_string: String

@export var starts_with: bool:
	get: return first_string.begins_with(second_string)

@export var contains: bool:
	get: return first_string.contains(second_string)

@export var ends_with: bool:
	get: return first_string.ends_with(second_string)
