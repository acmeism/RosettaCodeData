sub 𝑳 ( $𝑳0 = 1, $𝑳1 = 1, $𝑳add = 1 ) { $𝑳0, $𝑳1, { $^n2 + $^n1 + $𝑳add } ... * }

# Part 1
say "The first 25 Leonardo numbers:";
put 𝑳()[^25];

# Part 2
say "\nThe first 25 numbers using 𝑳0 of 0, 𝑳1 of 1, and adder of 0:";
put 𝑳( 0, 1, 0 )[^25];
