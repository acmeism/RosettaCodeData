use Prime::Factor;

my \𝜑 = 0, |(1..*).hyper.map: -> \t { t * [*] t.&prime-factors.squish.map: { 1 - 1/$_ } }

printf "𝜑(%2d) = %3d %s\n", $_, 𝜑[$_], $_ - 𝜑[$_] - 1 ?? '' !! 'Prime' for 1 .. 25;

(1e2, 1e3, 1e4, 1e5).map: -> $limit {
    say "\nCount of primes <= $limit: " ~ +(^$limit).grep: {$_ == 𝜑[$_] + 1}
}
