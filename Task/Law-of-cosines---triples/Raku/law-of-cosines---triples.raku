multi triples (60, $n) {
    my %sq = (1..$n).map: { .² => $_ };
    my atomicint $i = 0;
    my @triples[2*$n];
    (1..^$n).race(:8degree).map: -> $a {
        for $a^..$n -> $b {
            my $cos = $a * $a + $b * $b - $a * $b;
            @triples[$i⚛++] = $a, %sq{$cos}, $b if %sq{$cos}:exists;
        }
    }
    @triples.grep: so *;
}

multi triples (90, $n) {
    my %sq = (1..$n).map: { .² => $_ };
    my atomicint $i = 0;
    my @triples[2*$n];
    (1..^$n).race(:8degree).map: -> $a {
        for $a^..$n -> $b {
            my $cos = $a * $a + $b * $b;
            @triples[$i⚛++] = $a, $b, %sq{$cos} and last if %sq{$cos}:exists;
        }
    }
    @triples.grep: so *;
}

multi triples (120, $n) {
    my %sq = (1..$n).map: { .² => $_ };
    my atomicint $i = 0;
    my @triples[2*$n];
    (1..^$n).race(:8degree).map: -> $a {
        for $a^..$n -> $b {
            my $cos = $a * $a + $b * $b + $a * $b;
            @triples[$i⚛++] = $a, $b, %sq{$cos} and last if %sq{$cos}:exists;
        }
    }
    @triples.grep: so *;
}

use Sort::Naturally;

my $n = 13;
say "Integer triangular triples for sides 1..$n:";
for 120, 90, 60 -> $angle {
    my @itt = triples($angle, $n);
    if $angle == 60 { push @itt, "$_ $_ $_" for 1..$n }
    printf "Angle %3d° has %2d solutions: %s\n", $angle, +@itt, @itt.sort(&naturally).join(', ');
}

my ($angle, $count) = 60, 10_000;
say "\nExtra credit:";
say "$angle° integer triples in the range 1..$count where the sides are not all the same length: ", +triples($angle, $count);
