shared void run() {
	
	//integers divided by zero throw an exception
	try {
		value a = 1 / 0;
	} catch (Exception e) {
		e.printStackTrace();
	}

	//floats divided by zero produce infinity
	print(1.0 / 0 == infinity then "division by zero!" else "not division by zero!");
}
