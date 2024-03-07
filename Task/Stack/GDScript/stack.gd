extends Node2D

func _ready() -> void:
	# Empty stack creation.
	var stack : Array = []
	
	# In Godot 4.2.1 nothing happens here.
	stack.pop_back()
	
	if stack.is_empty():
		print("Stack is empty.")
	
	stack.push_back(3)
	stack.push_back("Value")
	stack.push_back(1.5e32)
	print(stack)
	
	print("Last element is: " + str(stack.back()))
	
	stack.pop_back()
	print(stack)
	print("Last element is: " + str(stack.back()))
	if not stack.is_empty():
		print("Stack is not empty.")
	return
