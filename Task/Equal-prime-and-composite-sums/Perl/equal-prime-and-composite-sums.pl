use strict;
use warnings;
use feature <say state>;
use ntheory <is_prime next_prime>;

sub comma  { reverse ((reverse shift) =~ s/(.{3})/$1,/gr) =~ s/^,//r }
sub suffix { my($d) = $_[0] =~ /(.)$/; $d == 1 ? 'st' : $d == 2 ? 'nd' : $d == 3 ? 'rd' : 'th' }

sub prime_sum {
    state $s = state $p = 2; state $i = 1;
    if ($i < (my $n = shift) ) { do { $s += $p = next_prime($p) } until ++$i == $n }
    $s
}

sub composite_sum {
    state $s = state $c = 4; state $i = 1;
    if ($i < (my $n = shift) ) { do { 1 until ! is_prime(++$c); $s += $c } until ++$i == $n }
    $s
}

my $ci++;
for my $pi (1 .. 5_012_372) {
    next if prime_sum($pi) < composite_sum($ci);
    printf( "%20s - %11s prime sum, %12s composite sum\n",
        comma(prime_sum $pi), comma($pi).suffix($pi), comma($ci).suffix($ci))
        and next if prime_sum($pi) == composite_sum($ci);
    $ci++;
    redo
}
