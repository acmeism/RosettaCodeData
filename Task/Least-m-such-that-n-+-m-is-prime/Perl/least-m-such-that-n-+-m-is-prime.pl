use strict;
use warnings;
use ntheory qw<next_prime factorial vecfirstidx>;

my($n,@least_m) = 0;
do {
    my $f = factorial($n++);
    push @least_m, next_prime($f) - $f;
} until $least_m[-1] > 10000;

print "Least positive m such that n! + m is prime; first fifty:\n";
print sprintf(('%4d')x50, @least_m[0..49]) =~ s/.{40}\K(?=.)/\n/gr . "\n\n";

for my $n (map { 1000 * $_ } 1..10) {
    my $key = vecfirstidx { $_ > $n } @least_m;
    printf "First m > $n is %d at position %d\n", $least_m[$key], $key;
}
