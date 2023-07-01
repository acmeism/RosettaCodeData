(
z = { |n|
	case
	{ n <= 0 } { 1 }
	{ n == 1 } { 0 }
	{ (n - 1) * (z.(n - 1) + z.(n - 2)) }
};
p = { |i| i.asPaddedString(10, " ") };
"n    derangements    subfactorial".postln;
(0..9).do { |i|
	var derangements = f.(i).all;
	var subfactorial = z.(i);
	"%    %    %\n".postf(i, p.(derangements.size), p.(subfactorial));
};
)
