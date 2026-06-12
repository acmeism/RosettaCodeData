use strict; use warnings; use feature 'state';
use Math::AnyNum <next_prime ceil>;

sub abbr { my $d=shift; my $l = length $d; $l < 41 ? $d : substr($d,0,20) . '..' . substr($d,-20) . " ($l digits)" }

sub succ_prime {
    state $sum = 0;
    my $next = next_prime ceil( 1 / (1-$sum) );
    $sum += 1/$next;
    $next
}

printf "%2d: %s\n", $_, abbr succ_prime for 1..14;
