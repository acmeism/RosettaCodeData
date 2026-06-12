use v5.36;
use experimental 'for_list';
use ntheory <gcd divisors vecall>;

sub Zsigmondy ($A, $B, $c) {
    my @aexp = map { $A ** $_ } 0..$c;
    my @bexp = map { $B ** $_ } 0..$c;
    my @z;
    for my $n (1..$c) {
        for my $d (sort { $b <=> $a } divisors $aexp[$n] - $bexp[$n]) {
            push @z, $d and last if vecall { gcd($aexp[$_] - $bexp[$_], $d) == 1 } 1..$n-1
        }
        return @z if 20 == @z
    }
}

for my($name,$a,$b) (
    'A064078: Zsigmondy(n,2,1)', 2,1,
    'A064079: Zsigmondy(n,3,1)', 3,1,
    'A064080: Zsigmondy(n,4,1)', 4,1,
    'A064081: Zsigmondy(n,5,1)', 5,1,
    'A064082: Zsigmondy(n,6,1)', 6,1,
    'A064083: Zsigmondy(n,7,1)', 7,1,
    'A109325: Zsigmondy(n,3,2)', 3,2,
    'A109347: Zsigmondy(n,5,3)', 5,3,
    'A109348: Zsigmondy(n,7,3)', 7,3,
    'A109349: Zsigmondy(n,7,5)', 7,5,
) {
    say "\n$name:\n" . join ' ', Zsigmondy($a, $b, 20)
}
