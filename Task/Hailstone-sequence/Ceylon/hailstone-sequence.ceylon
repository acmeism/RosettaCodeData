shared void run() {
	
	{Integer*} hailstone(variable Integer n) {
		variable [Integer*] stones = [n];
		while(n != 1) {
			n = if(n.even) then n / 2 else 3 * n + 1;
			stones = stones.append([n]);
		}
		return stones;
	}
	
	value hs27 = hailstone(27);
	print("hailstone sequence for 27 is ``hs27.take(3)``...``hs27.skip(hs27.size - 3).take(3)`` with length ``hs27.size``");
	
	variable value longest = hailstone(1);
	for(i in 2..100k - 1) {
		value current = hailstone(i);
		if(current.size > longest.size) {
			longest = current;
		}
	}
	print("the longest sequence under 100,000 starts with ``longest.first else "what?"`` and has length ``longest.size``");
}
