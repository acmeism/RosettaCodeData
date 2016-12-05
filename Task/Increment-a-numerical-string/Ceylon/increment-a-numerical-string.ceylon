shared void run() {
	
	"Increments a numeric string by 1. Returns a float or integer depending on the string.
	 Returns null if the string isn't a number."
	function inc(String string) =>
			if(exists integer = parseInteger(string)) then integer + 1
			else if(exists float = parseFloat(string)) then float + 1.0
			else null;
	
	value a = "1";
	print(a);
	value b = inc(a);
	print(b);
	value c = "1.0";
	print(c);
	value d = inc(c);
	print(d);
}
