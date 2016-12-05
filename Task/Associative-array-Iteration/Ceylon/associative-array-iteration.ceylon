shared void run() {

	value myMap = map {
		"foo" -> 5,
		"bar" -> 10,
		"baz" -> 15
	};
	
	for(key in myMap.keys) {
		print(key);
	}
	
	for(item in myMap.items) {
		print(item);
	}
	
	for(key->item in myMap) {
		print("``key`` maps to ``item``");
	}
	
}
