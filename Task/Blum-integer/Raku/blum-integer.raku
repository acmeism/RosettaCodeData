use List::Divvy;
use Lingua::EN::Numbers;

sub is-blum(Int $n ) {
    return False if $n.is-prime;
    my $factor = find-factor($n);
    return True if ($factor.is-prime && ( my $div = $n div $factor ).is-prime && ($div != $factor)
    && ($factor % 4 == 3) && ($div % 4 == 3));
    False;
}

sub find-factor ( Int $n, $constant = 1 ) {
    my $x      = 2;
    my $rho    = 1;
    my $factor = 1;
    while $factor == 1 {
        $rho *= 2;
        my $fixed = $x;
        for ^$rho {
            $x = ( $x * $x + $constant ) % $n;
            $factor = ( $x - $fixed ) gcd $n;
            last if 1 < $factor;
        }
    }
    $factor = find-factor( $n, $constant + 1 ) if $n == $factor;
    $factor;
}

my @blum = lazy (2..Inf).hyper(:1000batch).grep: &is-blum;
say "The first fifty Blum integers:\n" ~
  @blum[^50].batch(10)».fmt("%3d").join: "\n";
say '';

printf "The %9s Blum integer: %9s\n", .&ordinal-digit(:c), comma @blum[$_-1] for 26828, 1e5, 2e5, 3e5, 4e5;

say "\nBreakdown by last digit:";
printf "%d => %%%7.4f:\n", .key, +.value / 4e3 for sort @blum[^4e5].categorize: {.substr(*-1)}
