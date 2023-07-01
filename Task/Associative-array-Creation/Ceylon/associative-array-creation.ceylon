import ceylon.collection {

	ArrayList,
	HashMap,
	naturalOrderTreeMap
}

shared void run() {
	
	// the easiest way is to use the map function to create
	// an immutable map
	value myMap = map {
		"foo" -> 5,
		"bar" -> 10,
		"baz" -> 15,
		"foo" -> 6 // by default the first "foo" will remain
	};
	
	// or you can use the HashMap constructor to create
	// a mutable one
	value myOtherMap = HashMap {
		"foo"->"bar"
	};
	myOtherMap.put("baz", "baxx");
	
	// there's also a sorted red/black tree map
	value myTreeMap = naturalOrderTreeMap {
		1 -> "won",
		2 -> "too",
		4 -> "fore"
	};
	for(num->homophone in myTreeMap) {
		print("``num`` is ``homophone``");
	}
	
}
