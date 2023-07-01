import ceylon.numeric.float {

	sin, exp, asin, log
}

shared void run() {
	
	function cube(Float x) => x ^ 3;
	function cubeRoot(Float x) => x ^ (1.0 / 3.0);
	
	value functions = {sin, exp, cube};
	value inverses = {asin, log, cubeRoot};
	
	for([func, inv] in zipPairs(functions, inverses)) {
		print(compose(func, inv)(0.5));
	}
}
