// variable declaration
var table, chair;

// assignment
var table = 10, chair = -10;

// multiple assignment to the same value
table = chair = 0;

// multiple assignment to an array
(
var table, chair;
#table, chair = [10, -10];
#table ... chair = [10, -10, 2, 3]; // with ellipsis: now chair is [-10, 2, 3]
)

// the letters a-z are predeclared in the interpreter for interactive programming
a = 10; x = a - 8;

// variables are type-neutral and mutable: reassign to different objects
a = 10; a = [1, 2, 3]; a = nil;

// immutable variables (only in class definitions)
const z = 42;

// lexical scope
// the closures g and h refer to different values of their c
(
f = {
	var c = 0;
	{ c = c + 1 }
};
g = f.value;
h = f.value;
c = 100; // this doesn't change it.
)

// dynamic scope: environments
f = { ~table = ~table + 1 };
Environment.use { ~table = 100; f.value }; // 101.
Environment.use { ~table = -1; f.value }; // 0.

// there is a default environment
~table = 7;
f.value;

// lexical scope in environments:
(
Environment.use {
	~table = 100;
	f = { ~table = ~table + 1 }.inEnvir;
};
)
f.value; // 101.

// because objects keep reference to other objects, references are not needed:
// objects can take the role of variables. But there is a Ref object, that just holds a value

a = Ref([1, 2, 3]); // a reference to an array, can also be written as a quote `[1, 2, 3];
f = { |x| x.value = x.value.squared }; // a function that operates on a ref
f.(a); // `[ 1, 4, 9 ]

// proxy objects serve as delegators in environments. This can be called line by line:
ProxySpace.push;
~z // returns a NodeProxy
~z.play; // play a silent sound
~z = ~x + ~y; // make it the sum of two silent sounds
~x = { PinkNoise.ar(0.1) }; // … which now are noise,
~y = { SinOsc.ar(440, 0, 0.1) }; // and a sine tone
