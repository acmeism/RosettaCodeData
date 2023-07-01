main(){
	var fruits = {
		'apples':  'red',
		'oranges': 'orange',
		'bananas': 'yellow',
		'pears':   'green',
		'plums':   'purple'
	};
	
	print('Key Value pairs:');
	fruits.forEach( (fruits, color) => print( '$fruits are $color' ) );
	
	print('\nKeys only:');
	fruits.keys.forEach( ( key ) => print( key ) );
	
	print('\nValues only:');
	fruits.values.forEach( ( value ) => print( value ) );
}
