shared void run() {
	
	value numbers = [
		0,  1,  2,  4,  6,  7,  8, 11, 12, 14,
		15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
		25, 27, 28, 29, 30, 31, 32, 33, 35, 36,
		37, 38, 39
	];
	
	function asRangeFormattedString<Value>([Value*] values)
			given Value satisfies Enumerable<Value> {
		
		value builder = StringBuilder();
		
		void append(Range<Value> range) {
			if(!builder.empty) {
				builder.append(",");
			}
			if(1 <= range.size < 3) {
				builder.append(",".join(range));
			} else {
				builder.append("``range.first``-``range.last``");
			}
		}
		
		if(nonempty values) {
			variable value currentRange = values.first..values.first;
			for(val in values.rest) {
				if(currentRange.last.successor == val) {
					currentRange = currentRange.first..val;
				} else {
					append(currentRange);
					currentRange = val..val;
				}
			}
			append(currentRange);
		}
		return builder.string;
	}
	
	value rangeString = asRangeFormattedString(numbers);
	assert(rangeString == "0-2,4,6-8,11,12,14-25,27-33,35-39");
	print(rangeString);
}
