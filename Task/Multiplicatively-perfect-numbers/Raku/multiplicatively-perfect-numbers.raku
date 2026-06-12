use List::Divvy;
use Lingua::EN::Numbers;

constant @primes = (^∞).grep: &is-prime;
constant @cubes  = @primes.map: *³;

state $cube = 0;
sub is-mpn(Int $n ) {
    return False if $n.is-prime;
    if $n == @cubes[$cube] {
        ++$cube;
        return True
    }
    my $factor = find-factor($n);
    return True if ($factor.is-prime && ( my $div = $n div $factor ).is-prime && ($div != $factor));
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

constant @mpn = lazy 1, |(2..*).grep: &is-mpn;

say 'Multiplicatively perfect numbers less than 500:';
put @mpn.&upto(500).batch(10)».fmt("%3d").join: "\n";

put "\nThere are:";
for 5e2, 5e3, 5e4, 5e5, 5e6 {
   printf  "%8s MPNs less than %9s, %7s semiprimes.\n",
     comma(my $count = +@mpn.&upto($_)), .Int.&comma,
     comma $count + @primes.map(*²).&upto($_) - @cubes.&upto($_) - 1;
}
