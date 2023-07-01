for (String fn : List.of("file1.txt","file2.txt")) {
	Path path = Path.of(fn);
	Files.writeString(path,
		Files.readString(path).replace("Goodbye London!", "Hello New York!"));
}
