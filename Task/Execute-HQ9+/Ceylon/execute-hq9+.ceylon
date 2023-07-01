shared void run() {
	
	void eval(String code) {

		variable value accumulator = 0;

		for(c in code.trimmed.lowercased) {
			switch(c)
			case('h') {
				print("Hello, world!");
			}
			case('q') {
				print(code);
			}
			case('9') {
				function bottles(Integer i) =>
						switch(i)
						case(0) "No bottles"
						case(1) "One bottle"
						else "``i`` bottles";
				for(i in 99..1) {
					print("``bottles(i)`` of beer on the wall,
					       ``bottles(i)`` of beer,
					       take one down and pass it around,
					       ``bottles(i - 1)`` of beer on the wall!");
				}
			}
			case('+') {
				accumulator++;
			}
			else {
				print("syntax error");
			}
		}
	}
	
	eval("hq9+");
}
