(
// Usage: ~arithmetic_mean.(x), where x is an array
// of numbers.
//
// Return the artithmetic mean of the values in x.
~arithmetic_mean = {
	arg x; (x.sum)/(x.size)
};

// Usage: ~geometric_mean.(x), where x is an array
// of positive or null numbers.
//
// Return the geometric mean of the values in x.
~geometric_mean = {
	arg x; (x.product)**(1/(x.size))
};

// Usage: ~harmonic_mean.(x), where x is an array
// of non-null numbers.
//
// Return the harmonic mean of the values in x.
~harmonic_mean = {
	arg x; (x.size)/((1/x).sum)
};

~x = Array.fill(10, {|i| i + 1});
"Array: ".post; ~x.postln;
"----------------------------------".postln;
"Arithmetic mean:\t".post; ~arithmetic_mean.(~x).postln;
"Geometric mean:\t".post; ~geometric_mean.(~x).postln;
"Harmonic mean:\t".post; ~harmonic_mean.(~x).postln;
)
