constant @fib-word = '1', '0', { $^b ~ $^a } ... *;
constant @fib-ones = 1, 0, * + * ... *;
constant @fib-chrs = 1, 1, * + * ... *;

multi entropy(0) { 0 }
multi entropy(1) { 0 }
multi entropy($n) {
    my $chars = @fib-chrs[$n];
    my $ones  = @fib-ones[$n];
    my $zeros = $chars - $ones;
    -log(2) R/
        [+] map -> \p { p * log p },
            $ones / $chars, $zeros / $chars
}

for 0..100 -> $n {
    printf "%5d\t%21d\t%.15e\t%s\n",
	    $n, @fib-chrs[$n], entropy($n), $n > 9 ?? '' !! @fib-word[$n];
}
