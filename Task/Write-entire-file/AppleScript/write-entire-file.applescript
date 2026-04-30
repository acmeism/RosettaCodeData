on overwrite(filepath, str)
	set fp to open for access file filepath with write permission
	set eof of fp to 0
	write str to fp
	close access fp
end overwrite
