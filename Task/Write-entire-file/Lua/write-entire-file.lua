function writeFile (filename, data)
	local f = io.open(filename, 'w')
	f:write(data)
	f:close()
end

writeFile("stringFile.txt", "Mmm... stringy.")
