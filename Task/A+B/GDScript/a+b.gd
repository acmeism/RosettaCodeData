@tool
extends Node

@export var input: String:
	set(value):
		input = value # Save the input field

		var fields := value.split(" ", false) # Split by spaces
		if len(fields) == 2: # Basic input validation
			output = str(int(fields[0]) + int(fields[1]))
		else: # Invalid input
			output = ""

@export var output: String
