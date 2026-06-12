use v5.36;
use enum qw(False True);

sub table ($c, @V) { my $t = $c * (my $w = 5); ( sprintf( ('%'.$w.'d')x@V, @V) ) =~ s/.{1,$t}\K/\n/gr }

sub is_idoneal ($n) {
    LOOP:
    for my $a (1 .. $n) {
        for my $b ($a+1 .. $n) {
            last if $a*$b + $a + $b > $n;
            for my $c ($b+1 .. $n) {
                return False if $n == (my $sum = $a*$b + $b*$c + $c*$a);
                last if $sum > $n;
            }
        }
    }
    True
}

say table 10, grep { is_idoneal $_ } 1..1850;
