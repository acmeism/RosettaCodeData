module jortsort;

import std.algorithm : sort, SwapStrategy;

bool jortSort(T)(T[] array) {
	auto originalArray = array.dup;
	sort!("a < b", SwapStrategy.stable)(array);
	return originalArray == array;
}

unittest {
	assert(jortSort([1, 2, 3]));
	assert(!jortSort([1, 6, 3]));
	assert(jortSort(["apple", "banana", "orange"]));
	assert(!jortSort(["two", "one", "three"]));
}
