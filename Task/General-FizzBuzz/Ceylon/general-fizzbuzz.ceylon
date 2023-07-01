shared void run() {
	
	print("enter the max value");
	assert(exists maxLine = process.readLine(),
		exists max = parseInteger(maxLine));

	print("enter your number/word pairs
	       enter a blank line to stop");

	variable value divisorsToWords = map<Integer, String> {};

	while(true) {
		value line = process.readLine();
		assert(exists line);
		if(line.trimmed.empty) {
			break;
		}
		value pair = line.trimmed.split().sequence();
		if(exists first = pair.first,
			exists integer = parseInteger(first),
			exists word = pair[1]) {
			divisorsToWords = divisorsToWords.patch(map {integer -> word});
		}
	}

	value divisors = divisorsToWords.keys.sort(byIncreasing(Integer.magnitude));
	for(i in 1..max) {
		value builder = StringBuilder();
		for(divisor in divisors) {
			if(divisor.divides(i), exists word = divisorsToWords[divisor]) {
				builder.append(word);
			}
		}
		if(builder.empty) {
			print(i);
		} else {
			print(builder.string);
		}
	}
}
