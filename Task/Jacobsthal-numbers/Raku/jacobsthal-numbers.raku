my $jacobsthal = cache lazy 0, 1, * × 2 + * … *;
my $jacobsthal-lucas = lazy 2, 1, * × 2 + * … *;

say "First 30 Jacobsthal numbers:";
say $jacobsthal[^30].batch(5)».fmt("%9d").join: "\n";

say "\nFirst 30 Jacobsthal-Lucas numbers:";
say $jacobsthal-lucas[^30].batch(5)».fmt("%9d").join: "\n";

say "\nFirst 20 Jacobsthal oblong numbers:";
say (^∞).map( { $jacobsthal[$_] × $jacobsthal[$_+1] } )[^20].batch(5)».fmt("%11d").join: "\n";

say "\nFirst 20 Jacobsthal primes:";
say $jacobsthal.grep( &is-prime )[^20].join: "\n";
