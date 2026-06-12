use v5.36;
use bigrat;
use experimental <builtin for_list>;
use List::Util <min product>;

sub ceiling ($n) { $n == int $n ? $n : int $n + 1 }
sub abbr ($d) { my $l = length $d; $l < 61 ? $d : substr($d,0,30) . '..' . substr($d,-30) . " ($l digits)" }

sub to_engel ($rat) {
    my @E;
    while ($rat) {
        push @E, ceiling 1/$rat;
        $rat = $rat*$E[-1] - 1;
    }
    @E
}

sub from_engel (@expanded) {
    my @a;
    sum( map { push @a, $_; 1/product(@a) } @expanded )
}

for my($rat,$p) (
    #  low precision 𝜋, 𝑒, √2 and 1.5 to powers
    3.14159265358979, 15,
    2.71828182845904, 15,
    1.414213562373095, 16,
    1.5**5, 6,
    1.5**8, 10,

    # high precision 𝜋, 𝑒, and √2
3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679821480865132823066470938446095505822317253594081284811174502841027019385211, 176,
    2.71828182845904523536028747135266249775724709369995957496696762772407663035354759457138217852516642743, 102,
    1.4142135623730950488016887242096980785696718753769480731766797379907324784621070388503875343276415727350138462309122970249248360558507372126441214970999358314132226659275055927558, 179,
    ) {
    say "Rational number: " . abbr $rat->as_float($p);
    my $terms = join ' ', my @expanded = to_engel $rat;
    say "Engel expansion: " . (length($terms) > 100 ? $terms =~ s/^(.{90}\S*).*$/$1/r . '... (' . +@expanded . ' terms)' : $terms);
    say " Converted back: " . abbr from_engel(@expanded)->as_float($p);
    say '';
}
