use v5.36;
use bigint;
use ntheory 'is_prime';

sub abbr ($d) { my $l = length $d; $l < 61 ? $d : substr($d,0,30) . '..' . substr($d,-30) . " ($l digits)" }

my($p,@W) = 2;
until (@W == 30) {
    next unless 0 != ++$p % 2;
    push @W, $p if is_prime($p) and is_prime((2**$p + 1)/3)
}

printf "%2d: %5d - %s\n", $_+1, $W[$_], abbr( (2**$W[$_] + 1) / 3) for 0..$#W;
