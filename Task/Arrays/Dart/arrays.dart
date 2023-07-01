main(){
	// Dart uses Lists which dynamically resize by default
	final growable = [ 1, 2, 3 ];

        // Add to the list using the add method
	growable.add(4);

	print('growable: $growable');

	// You can pass an int to the constructor to create a fixed sized List
	final fixed = List(3);
	
	// We must assign each element individually using the Subscript operator
	// using .add would through an error
	fixed[0] = 'one';
	fixed[1] = 'two';
	fixed[2] = 'three';

	print('fixed: $fixed');

	// If we want to create a fixed list all at once we can use the of constructor
	// Setting growable to false is what makes it fixed
	final fixed2 = List.of( [ 1.5, 2.5, 3.5 ], growable: false);

	print('fixed2: $fixed2');
	
	// A potential gotcha involving the subscript operator [] might surprise JavaScripters
	// One cannot add new elements to a List using the subscript operator
	// We can only assign to existing elements, even if the List is growable

	final gotcha = [ 1, 2 ];	
	// gotcha[2] = 3 would cause an error in Dart, but not in JavaScript
	// We must first add the new element using .add
	gotcha.add(3);
	// Now we can modify the existing elements with the subscript
	gotcha[2] = 4;

	print('gotcha: $gotcha');


}
