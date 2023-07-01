use 5.020;
use warnings;
use ntheory qw/:all/;
use experimental qw/signatures/;

sub chernick_carmichael_factors ($n, $m) {
    (6*$m + 1, 12*$m + 1, (map { (1 << $_) * 9*$m + 1 } 1 .. $n-2));
}

sub chernick_carmichael_number ($n, $callback) {

    my $multiplier = ($n > 4) ? (1 << ($n-4)) : 1;

    for (my $m = 1 ; ; ++$m) {
        my @f = chernick_carmichael_factors($n, $m * $multiplier);
        next if not vecall { is_prime($_) } @f;
        $callback->(@f);
        last;
    }
}

foreach my $n (3..9) {
    chernick_carmichael_number($n, sub (@f) { say "a($n) = ", vecprod(@f) });
}
