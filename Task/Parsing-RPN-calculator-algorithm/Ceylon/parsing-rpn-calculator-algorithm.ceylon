import ceylon.collection {

	ArrayList
}

shared void run() {
	
	value ops = map {
		"+" -> plus<Float>,
		"*" -> times<Float>,
		"-" -> ((Float a, Float b) => a - b),
		"/" -> ((Float a, Float b) => a / b),
		"^" -> ((Float a, Float b) => a ^ b)
	};
	
	void printTableRow(String|Float token, String description, {Float*} stack) {
		print("``token.string.padTrailing(8)````description.padTrailing(30)````stack``");
	}
	
	function calculate(String input) {
		
		value stack = ArrayList<Float>();
		value tokens = input.split().map((String element)
			=> if(ops.keys.contains(element)) then element else parseFloat(element));
		
		print("Token   Operation                     Stack");
		
		for(token in tokens.coalesced) {
			if(is Float token) {
				stack.push(token);
				printTableRow(token, "push", stack);
			} else if(exists op = ops[token], exists first = stack.pop(), exists second = stack.pop()) {
				value result = op(second, first);
				stack.push(result);
				printTableRow(token, "perform ``token`` on ``formatFloat(second, 1, 1)`` and ``formatFloat(first, 1, 1)``", stack);
			} else {
				throw Exception("bad syntax");
			}
		}
		return stack.pop();
	}
	
	print(calculate("3 4 2 * 1 5 - 2 3 ^ ^ / +"));
}
