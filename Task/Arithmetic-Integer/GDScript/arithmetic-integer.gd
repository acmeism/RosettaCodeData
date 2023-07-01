@tool
extends Node

@export var a: int:
	set(value):
		a = value
		refresh()

@export var b: int:
	set(value):
		b = value
		refresh()

# Output properties
@export var sum: int
@export var difference: int
@export var product: int
@export var integer_quotient: int
@export var remainder: int
@export var exponentiation: int
@export var divmod: int

func refresh():
	sum = a + b
	difference = a - b
	product = a * b
	integer_quotient = a / b # Rounds towards 0
	remainder = a % b # Matches the sign of a
	exponentiation = pow(a, b)
