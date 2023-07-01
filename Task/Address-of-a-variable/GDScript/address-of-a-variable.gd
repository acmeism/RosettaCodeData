extends MainLoop


func _process(_delta: float) -> bool:
	var a := Node.new()
	var b := Node.new()

	# a and b are different objects with different RIDs
	print(a.get_instance_id())
	print(b.get_instance_id())

	assert(a != b)
	assert(a.get_instance_id() != b.get_instance_id())

	# Set b to refer to the same object as a
	b.free()
	b = a

	# a and b are now the same object and have the same RID
	print(a.get_instance_id())
	print(b.get_instance_id())

	assert(a == b)
	assert(a.get_instance_id() == b.get_instance_id())

	a.free()
	return true # Exit
