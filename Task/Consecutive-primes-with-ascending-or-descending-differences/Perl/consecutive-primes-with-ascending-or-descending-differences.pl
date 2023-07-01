use strict;
use warnings;
use feature 'say';
use ntheory 'primes';
use List::AllUtils <indexes max>;

my $limit  = 1000000;
my @primes = @{primes( $limit )};

sub runs {
    my($op) = @_;
    my @diff = my $diff = my $run = 1;
    push @diff, map {
        my $next = $primes[$_] - $primes[$_ - 1];
        if ($op eq '>') { if ($next > $diff) { ++$run } else { $run = 1 } }
        else            { if ($next < $diff) { ++$run } else { $run = 1 } }
        $diff = $next;
        $run
    } 1 .. $#primes;

    my @prime_run;
    my $max = max @diff;
    for my $r ( indexes { $_ == $max } @diff ) {
        push @prime_run, join ' ', map { $primes[$r - $_] } reverse 0..$max
    }
    @prime_run
}

say   "Longest run(s) of ascending prime gaps up to $limit:\n"  . join "\n", runs('>');
say "\nLongest run(s) of descending prime gaps up to $limit:\n" . join "\n", runs('<');
