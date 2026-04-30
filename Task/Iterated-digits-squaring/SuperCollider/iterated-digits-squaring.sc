(
// Usage: ~iterated_digits_squaring.(n), where n is a
//        positive integer
//
// Apply the iterated digits squaring algorithm to n and
// return result (1 or 89).
~iterated_digits_squaring = {
	arg n; var digits = n.asDigits,
	squared_sum = (digits*digits).sum;


	while{(squared_sum != 1) && (squared_sum!= 89)}{
		digits = squared_sum.asDigits;
		squared_sum = (digits*digits).sum;
	};

	squared_sum
};

// Usage: ~count_end_val_89.(max), where max is a positive
//        integer
//
// Return the number of integers from 1 to max (inclusive) that
// yield 89 when submitted to the iterated digits squaring
// algorithm.
~count_end_val_89 = {
	arg max; var count = 0, prog = 0, show = true;

	"progress (%): ".post;

	(max + 1).do{ |n|
		if( floor(n/(0.01*max)) >= (prog + 10) ){
			prog = prog + 10; show = true;}{};

		if(show == true){
			prog.post; " ".post; show = false}{};

		if(~iterated_digits_squaring.(n + 1) == 89){
			count = count + 1}{};
	};
	"\ndone".postln;

	count;
};

~r = ~count_end_val_89.(1000000 - 1);
"-------\nResult for 1 <= n < 1,000,000: ".post; ~r.postln;
"".postln;
~r = ~count_end_val_89.(100000000 - 1);
"-------\nResult for 1 <= n < 100,000,000: ".post; ~r.postln;
)
