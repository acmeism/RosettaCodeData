software {
	var data = ""
	var file = open("input.txt")
	loop {
		! data += file(256)
		issues {
			break
		}
	}
	delete("output.txt")
	file = open("output.txt")
	file(data)
}
