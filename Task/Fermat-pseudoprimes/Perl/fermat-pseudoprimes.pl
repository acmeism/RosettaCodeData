use v5.36;
use ntheory 'is_prime';

sub expmod ($a, $b, $n) {
    my $c = 1;
    do {
        ($c *= $a) %= $n if $b % 2;
        ($a *= $a) %= $n;
    } while ($b = int $b/2);
    $c
}

my $threshold = 50000;
say "For each base: # of terms up to $threshold, first 20 displayed";
for my $b (1..20) {
    my @pseudo = grep { !is_prime($_) && (1 == expmod $b, $_ - 1, $_) } 1..$threshold;
    printf "base %2d: %5d (%s)\n", $b, $#pseudo, join ' ', @pseudo[1..20];
}
