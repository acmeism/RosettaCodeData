function writeFile(filename, data)
	f = open(filename, "w")
	write(f, data)
	close(f)
end

writeFile("test.txt", "Hi there.")
