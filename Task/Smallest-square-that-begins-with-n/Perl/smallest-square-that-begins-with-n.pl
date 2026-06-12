use strict;
use warnings;
use constant Inf => 10e12; # arbitrarily large value

for my $n (1..49) {
   do { printf "%2d: %3d^2 = %5d\n", $n, $_, $_**2 and last if $_**2 =~ /^$n/ } for 1..Inf
}
