use strict;
use warnings;
use feature 'say';
use  ntheory 'is_prime';

my @sp = my $previous = 2;
do {
    my($next,$n);
    while () { last if is_prime( $next = $previous + ++$n**2 ) }
    push @sp, $next;
    $previous = $next;
} until $sp[-1] >= 16000;

pop @sp and say ((sprintf '%-7d'x@sp, @sp) =~ s/.{1,$#sp}\K\s/\n/gr);
