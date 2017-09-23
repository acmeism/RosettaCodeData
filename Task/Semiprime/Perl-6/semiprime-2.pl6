sub is-semiprime ( Int $n where * > 0 ) {
    return False if $n.is-prime;
    my $factor = find-factor( $n );
    return True if $factor.is-prime && ( $n div $factor ).is-prime;
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

INIT my $start = now;

# Infinite list of semiprimes
constant @semiprimes = 4, 6, 9, -> $p { ($p + 1 ... &is-semiprime).tail } ... *;

# Show the semiprimes < 100
say 'Semiprimes less than 100:';
say @semiprimes[^ @semiprimes.first: * > 100, :k ], "\n";

# Check individual integers, or in this case, a range
my $s = 2⁹⁷ - 1;
say "Is $_ semiprime?: ", is-semiprime( $_ ) for $s .. $s + 30;

say 'elapsed seconds: ', now - $start;
