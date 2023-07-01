use strict;
use feature 'say';

use List::Util 'sum';
use POSIX 'floor';
use Algorithm::Combinatorics 'subsets';
use ntheory <is_prime divisors>;

sub abundant {
    my($x) = @_;
    my $s = sum( my @l = is_prime($x) ? 1 : grep { $x != $_ } divisors($x) );
    $s > $x ? ($s, sort { $b <=> $a } @l) : ();
}

my(@weird,$n);
while () {
    $n++;
    my ($sum, @div) = abundant($n);
    next unless $sum;        # Weird number must be abundant, skip it if it isn't.
    next if $sum / $n > 1.1; # There aren't any weird numbers with a sum:number ratio greater than 1.08 or so.

    if ($n >= 10430 and (! int $n%70) and is_prime(int $n/70)) {
        # It's weird. All numbers of the form 70 * (a prime 149 or larger) are weird
    } else {
        my $next;
        my $l = shift @div;
        my $iter = subsets(\@div);
        while (my $s = $iter->next) {
            ++$next and last if sum(@$s) == $n - $l;
        }
        next if $next;
    }
    push @weird, $n;
    last if @weird == 25;
}

say "The first 25 weird numbers:\n" . join ' ', @weird;
