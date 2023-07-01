import std.stdio;
import std.algorithm;
import std.random;
import std.range;

int pancake(int n) {
    int gap = 2, sum = 2, adj = -1;
	
    while (sum < n) {
        adj++;
        gap = 2 * gap - 1;
        sum += gap;
    }
	
    return n + adj;
}

Range pancakeSort(Range)(Range r) {
	foreach_reverse (immutable i; 2 .. r.length + 1) {
		immutable maxIndex = i - r[0 .. i].minPos!q{a > b}.length;
		
		if (maxIndex + 1 != i) {
			if (maxIndex != 0) {
				r[0 .. maxIndex + 1].reverse();
			}
			
			r[0 .. i].reverse();
		}
	}
	
	return r;
}

void main() {
	writeln("\nThe maximum number of flips to sort a given number of elements is:\n");
	
	foreach (i; 1..11)
	{
		auto data = iota(1, i+1).array;
		
		if (i != 1) {
			// Protection against the edge case data.lenght == 1 not handled by randomShuffle
			// where also data is invariant with regard to pancakeSort
			do
				data.randomShuffle;
			while (data.isSorted);
		}
		
		auto sortedData = data.dup;
		sortedData.pancakeSort;
		
		writefln("pancake(%2d) = %2d  e.g  %s  ->  %s", i, pancake(i), data, sortedData);
	}
}
