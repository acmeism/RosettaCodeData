my @honaker = lazy (^∞).hyper.grep(&is-prime).kv.grep: (1 + *).comb.sum == *.comb.sum;

say "First 50 Honaker primes (index, prime):\n" ~ @honaker[^50].map(&format).batch(5).join: "\n";
say "\nTen thousandth: " ~ @honaker[9999].&format;

sub format ($_) { sprintf "(%3d, %4d)", 1 + .[0], .[1] }
