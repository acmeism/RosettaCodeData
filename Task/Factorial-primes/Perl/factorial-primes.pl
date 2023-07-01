use v5.36;
use ntheory <is_prime factorial>;

sub show ($d) { my $l = length $d; $l < 41 ? $d : substr($d,0,20) . '..' . substr($d,-20) . " ($l digits)" }

my($cnt,$n);
my $fmt = "%2d: %3d! %s 1 = %s\n";

while () {
    my $f = factorial ++$n;
    if (is_prime $f-1) { printf $fmt, ++$cnt, $n, '-', show $f-1 }
    if (is_prime $f+1) { printf $fmt, ++$cnt, $n, '+', show $f+1 }
    last if $cnt == 30;
}
