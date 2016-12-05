shared void run() {
	
	//create a list of closures with a list comprehension
	value closures = [for(i in 0:10) () => i ^ 2];
	
	for(i->closure in closures.indexed) {
		print("closure number ``i`` returns: ``closure()``");
	}
}
