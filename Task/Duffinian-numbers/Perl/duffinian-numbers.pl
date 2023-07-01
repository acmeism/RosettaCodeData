use strict;
use warnings;
use feature <say state>;
use List::Util 'max';
use ntheory qw<divisor_sum is_prime gcd>;

sub table { my $t = shift() * (my $c = 1 + max map {length} @_); ( sprintf( ('%'.$c.'s')x@_, @_) ) =~ s/.{1,$t}\K/\n/gr }

sub duffinian {
    my($n) = @_;
    state $c = 1; state @D;
    do { push @D, $c if ! is_prime ++$c and 1 == gcd($c,divisor_sum($c)) } until @D > $n;
    $D[$n];
}

say "First 50 Duffinian numbers:";
say table 10, map { duffinian $_-1 } 1..50;

my(@d3,@triples) = (4, 8, 9); my $n = 3;
while (@triples < 39) {
    push @triples, '('.join(', ',@d3).')' if $d3[1] == 1+$d3[0] and $d3[2] == 2+$d3[0];
    shift @d3 and push @d3, duffinian ++$n;
}

say 'First 39 Duffinian triplets:';
say table 3, @triples;
