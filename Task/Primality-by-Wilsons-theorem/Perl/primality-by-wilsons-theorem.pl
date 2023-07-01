use strict;
use warnings;
use feature 'say';
use ntheory qw(factorial);

my($ends_in_7, $ends_in_3);

sub is_wilson_prime {
    my($n) = @_;
    $n > 1 or return 0;
    (factorial($n-1) % $n) == ($n-1) ? 1 : 0;
}

for (0..50) {
    my $m = 3 + 10 * $_;
    $ends_in_3 .= "$m " if is_wilson_prime($m);
    my $n = 7 + 10 * $_;
    $ends_in_7 .= "$n " if is_wilson_prime($n);
}

say $ends_in_3;
say $ends_in_7;
