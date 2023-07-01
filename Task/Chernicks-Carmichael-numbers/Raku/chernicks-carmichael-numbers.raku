use Inline::Perl5;
use ntheory:from<Perl5> <:all>;

sub chernick-factors ($n, $m) {
    6×$m + 1, 12×$m + 1, |((1 .. $n-2).map: { (1 +< $_) × 9×$m + 1 } )
}

sub chernick-carmichael-number ($n) {

    my $multiplier = 1 +< (($n-4) max 0);
    my $iterator   = $n < 5 ?? (1 .. *) !! (1 .. *).map: * × 5;

    $multiplier × $iterator.first: -> $m {
        [&&] chernick-factors($n, $m × $multiplier).map: { is_prime($_) }
    }

}

for 3 .. 9 -> $n {
    my $m = chernick-carmichael-number($n);
    my @f = chernick-factors($n, $m);
    say "U($n, $m): {[×] @f} = {@f.join(' ⨉ ')}";
}
