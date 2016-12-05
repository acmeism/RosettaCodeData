shared void run() {
	while(true) {
		print("please enter two numbers for me to add");
		value input = process.readLine();
		if(exists input) {
			value tokens = input.split();
			value numbers = tokens.map(parseInteger);
			if(numbers.any((Integer? element) => element is Null)) {
				print("numbers only, please");
			} else if(numbers.size != 2) {
				print("two numbers, please");
			} else if(!numbers.coalesced.every((Integer element) => -1k <= element <= 1k)) {
				print("only numbers between -1000 and 1000, please");
			} else if(exists a = numbers.first, exists b = numbers.last) {
				print(a + b);
			} else {
				print("something went wrong");
			}
		} else {
			break;
		}
	}
}
