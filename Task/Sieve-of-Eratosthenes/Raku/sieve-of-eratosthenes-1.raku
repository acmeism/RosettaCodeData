sub sieve( Int $limit ) {
    my @is-prime = False, False, slip True xx $limit - 1;

    gather for @is-prime.kv -> $number, $is-prime {
        if $is-prime {
            take $number;
            loop (my $s = $number**2; $s <= $limit; $s += $number) {
                @is-prime[$s] = False;
            }
        }
    }
}

(sieve 100).join(",").say;
