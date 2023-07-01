my $pell = cache lazy 0, 1, * + * × 2 … *;
my $pell-lucas = lazy 2, 2, * + * × 2 … *;

my $upto = 20;

say   "First $upto Pell numbers:\n" ~ $pell[^$upto];

say "\nFirst $upto Pell-Lucas numbers:\n" ~ $pell-lucas[^$upto];

say "\nFirst $upto rational approximations of √2 ({sqrt(2)}):\n" ~
(1..$upto).map({ sprintf "%d/%d - %1.16f", $pell[$_-1] + $pell[$_], $pell[$_], ($pell[$_-1]+$pell[$_])/$pell[$_] }).join: "\n";

say "\nFirst $upto Pell primes:\n" ~ $pell.grep(&is-prime)[^$upto].join: "\n";

say "\nIndices of first $upto Pell primes:\n" ~ (^∞).grep({$pell[$_].is-prime})[^$upto];

say "\nFirst $upto Newman-Shank-Williams numbers:\n" ~ (^$upto).map({ $pell[2 × $_, 2 × $_+1].sum });

say "\nFirst $upto near isosceles right triangles:";
map -> \p { printf "(%d, %d, %d)\n", |($_, $_+1 given $pell[^(2 × p + 1)].sum), $pell[2 × p + 1] }, 1..$upto;
