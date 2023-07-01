use utf8;
binmode STDOUT, ":utf8";

use ntheory qw(euler_phi);

my @𝜑 = euler_phi(0,10000);  # Returns list of all values in range

printf "𝜑(%2d) = %3d%s\n", $_, $𝜑[$_], $_ - $𝜑[$_] - 1 ? '' : ' Prime' for 1 .. 25;
print "\n";

for $limit (100, 1000, 10000) {
    printf "Count of primes <= $limit: %d\n", scalar grep {$_ == $𝜑[$_] + 1} 0..$limit;
}
