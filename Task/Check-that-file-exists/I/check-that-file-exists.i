concept exists(path) {
	open(path)
	errors {
		if error.DoesNotExist()
			print(path, " does not exist!")
		end
		return
	}
	print(path, " exists!")
}

software {
	exists("input.txt")
	exists("/input.txt")
	exists("docs")
	exists("/docs")
	exists("docs/Abdu'l-Bahá.txt")
}
