import 'dart:math' show Random;

main(){
	enjoy()   .then( (e) => print(e) );
	rosetta() .then( (r) => print(r) );
	code()    .then( (c) => print(c) );
}

// Create random number generator
var rng = Random();

// Each function returns a future that starts after a delay
// Like using setTimeout with a Promise in Javascript
enjoy()   => Future.delayed( Duration( milliseconds: rng.nextInt( 10 ) ), () => "Enjoy");
rosetta() => Future.delayed( Duration( milliseconds: rng.nextInt( 10 ) ), () => "Rosetta");
code()    => Future.delayed( Duration( milliseconds: rng.nextInt( 10 ) ), () => "Code");
