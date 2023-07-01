constant @fib-word = 1, 0, { $^b ~ $^a } ... *;

sub entropy {
    -log(2) R/
        [+] map -> \p { p * log p },
            $^string.comb.Bag.values »/» $string.chars
}
for @fib-word[^37] {
    printf "%5d\t%10d\t%.8e\t%s\n",
    (state $n)++, .chars, .&entropy, $n > 10 ?? '' !! $_;
}
