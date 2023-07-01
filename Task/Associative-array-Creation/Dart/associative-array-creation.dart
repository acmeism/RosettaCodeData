main() {
	var rosettaCode = { // Type is inferred to be Map<String, String>
		'task': 'Associative Array Creation'
	};

	rosettaCode['language'] = 'Dart';

	// The update function can be used to update a key using a callback
	rosettaCode.update( 'is fun',  // Key to update
		(value) => "i don't know", // New value to use if key is present
		ifAbsent: () => 'yes!' // Value to use if key is absent
	);
	
	assert( rosettaCode.toString() == '{task: Associative Array Creation, language: Dart, is fun: yes!}');
	
	// If we type the Map with dynamic keys and values, it is like a JavaScript object
	Map<dynamic, dynamic> jsObject = {
		'key': 'value',
		1: 2,
		1.5: [ 'more', 'stuff' ],
		#doStuff: () => print('doing stuff!') // #doStuff is a symbol, only one instance of this exists in the program. Would be :doStuff in Ruby
	};

	print( jsObject['key'] );
	print( jsObject[1] );
	
	for ( var value in jsObject[1.5] )
		print('item: $value');

	jsObject[ #doStuff ](); // Calling the function
	
	print('\nKey types:');
	jsObject.keys.forEach( (key) => print( key.runtimeType ) );
}
