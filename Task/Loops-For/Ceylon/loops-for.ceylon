shared void run() {
	
	for(i in 1..5) {
		for(j in 1..i) {
			process.write("*");
		}
		print("");
	}
}
