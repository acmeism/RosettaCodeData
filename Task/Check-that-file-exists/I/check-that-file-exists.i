function exists(""filename) {
	var file = open(filename)
	issues {
		print(filename+" does not exist")
		return
	}
	print(filename+" exists")
	close(file)
}

software {
	exists("input.txt")
	exists("/input.txt")
	exists("docs")
	exists("/docs")
}
