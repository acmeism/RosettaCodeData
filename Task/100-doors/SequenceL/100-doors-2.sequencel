main := flipDoors([1], 2);

flipDoors(openDoors(1), i) :=
	openDoors when i * i >= 100 else flipDoors(openDoors ++ [i * i], i + 1);
