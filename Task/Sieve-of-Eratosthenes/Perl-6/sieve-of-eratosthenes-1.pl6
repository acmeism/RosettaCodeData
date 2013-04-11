sub sieve( Int $limit ) {
    my @is-prime = False, False, True xx $limit - 1;

    gather for @is-prime.kv -> $number, $is-prime {
        if $is-prime {
            take $number;
            @is-prime[$_] = False if $_ %% $number for $number**2 .. $limit;
        }
    }
}

(sieve 100).join(",").say;
