shared void run() {
	
	function fs(Integer f(Integer n), {Integer*} s) => s.map(f);
	
	function f1(Integer n) => n * 2;
	function f2(Integer n) => n ^ 2;
	
	value fsCurried = curry(fs);
	value fsf1 = fsCurried(f1);
	value fsf2 = fsCurried(f2);
	
	value ints = 0..3;
	print("fsf1(``ints``) is ``fsf1(ints)`` and fsf2(``ints``) is ``fsf2(ints)``");
	
	value evens = (2..8).by(2);
	print("fsf1(``evens``) is ``fsf1(evens)`` and fsf2(``evens``) is ``fsf2(evens)``");
}
