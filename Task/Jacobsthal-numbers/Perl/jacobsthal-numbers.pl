use strict;
use warnings;
use feature <say state>;
use bigint;
use List::Util 'max';
use ntheory 'is_prime';

sub table { my $t = 5 * (my $c = 1 + length max @_); ( sprintf( ('%'.$c.'d')x@_, @_) ) =~ s/.{1,$t}\K/\n/gr }

sub jacobsthal       { my($n) = @_; state  @J = (0, 1); do { push  @J,  $J[-1] + 2 *  $J[-2]} until  @J > $n;  $J[$n] }
sub jacobsthal_lucas { my($n) = @_; state @JL = (2, 1); do { push @JL, $JL[-1] + 2 * $JL[-2]} until @JL > $n; $JL[$n] }

my(@j,@jp,$c,$n);
push @j, jacobsthal $_ for 0..29;
do { is_prime($n = ( 2**++$c - -1**$c ) / 3) and push @jp, $n } until @jp == 20;

say "First 30 Jacobsthal numbers:\n",        table @j;
say "First 30 Jacobsthal-Lucas numbers:\n",  table map { jacobsthal_lucas $_-1 } 1..30;
say "First 20 Jacobsthal oblong numbers:\n", table map { $j[$_-1] * $j[$_]     } 1..20;
say "First 20 Jacobsthal primes:\n",         join "\n", @jp;
