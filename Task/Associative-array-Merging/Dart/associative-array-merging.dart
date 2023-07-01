main() {
	var base = {
		'name':   'Rocket Skates',
		'price':  12.75,
		'color':  'yellow'
	};

	var newData = {
		'price': 15.25,
		'color': 'red',
		'year':  1974
	};

	var updated = Map.from( base ) // create new Map from base
		..addAll( newData ); // use cascade operator to add all new data
	
	assert( base.toString()    == '{name: Rocket Skates, price: 12.75, color: yellow}' );
	assert( updated.toString() == '{name: Rocket Skates, price: 15.25, color: red, year: 1974}');


}
