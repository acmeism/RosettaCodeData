use strict;
use warnings;
use feature 'say';
use  ntheory 'is_prime';

my @sp = my $previous = 2;
do {
    my($next,$n);
    while () { last if is_prime( $next = $previous + ++$n**3 ) }
    push @sp, $next;
    $previous = $next;
} until $sp[-1] >= 15000;

pop @sp and say join ' ', @sp;
