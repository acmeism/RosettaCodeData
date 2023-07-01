use v5.36;
use ntheory 'divisors';
use List::Util <max product>;

sub table ($c, @V) { my $t = $c * (my $w = 2 + length max @V); ( sprintf( ('%'.$w.'d')x@V, @V) ) =~ s/.{1,$t}\K/\n/gr }
sub proper_divisors ($n) { my @d = divisors($n); pop @d; @d }

sub is_N ($n) {
    state @N = 1;
    state $p = 1;
    do { push @N, $p if ++$p**3 == product proper_divisors($p); } until $N[$n];
    $N[$n-1]
}

say table 10, map { is_N $_ } 1..50;
printf "%5d %d\n", $_, is_N $_ for 500, 5000, 50000;
