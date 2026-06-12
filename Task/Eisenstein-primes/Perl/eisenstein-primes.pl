use v5.36;
use Math::AnyNum <pi mod max complex reals is_prime>;

my $omega = exp ( complex(0,2) * pi/3 ); my @E;

sub    norm (@p)     { $p[0]**2 - $p[0]*$p[1] + $p[1]**2 }
sub display (@p)     { sprintf '%+8.4f%+8.4fi', reals($p[0] + $omega*$p[1]) }
sub       X ($a, $b) { my @p; for my $x ($a..$b) { for my $y ($a..$b) { push @p, [$x, $y] } } @p }
sub   table ($c, @V) { my $t = $c * (my $w = 1 + max map { length } @V); ( sprintf( ('%'.$w.'s')x@V, @V) ) =~ s/.{1,$t}\K/\n/gr }

for (X -10, 10) {
    my($a,$b) = @$_;
    my $c = max abs($a), abs($b);
    push @E, [@$_] if ((0==$a or 0==$b or $a==$b) and is_prime $c and 2 == mod $c,3) or is_prime norm @$_
}
say table 4, (map { display @$_ } sort { norm(@$a) <=> norm(@$b) } @E)[0..99];
