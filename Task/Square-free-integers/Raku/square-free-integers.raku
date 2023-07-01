# Prime factorization routines
sub prime-factors ( Int $n where * > 0 ) {
    return $n if $n.is-prime;
    return [] if $n == 1;
    my $factor = find-factor( $n );
    flat prime-factors( $factor ), prime-factors( $n div $factor );
}

sub find-factor ( Int $n, $constant = 1 ) {
    return 2 unless $n +& 1;
    if (my $gcd = $n gcd 6541380665835015) > 1 {
        return $gcd if $gcd != $n
    }
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

# Task routine
sub is-square-free (Int $n) { my @v = $n.&prime-factors.Bag.values; @v.sum/@v <= 1 }

# The Task
# Parts 1 & 2
for 1, 145, 1e12.Int, 145+1e12.Int -> $start, $end {
    say "\nSquare─free numbers between $start and $end:\n",
    ($start .. $end).hyper(:4batch).grep( &is-square-free ).list.fmt("%3d").comb(84).join("\n");
}

# Part 3
for 1e2, 1e3, 1e4, 1e5, 1e6 {
    say "\nThe number of square─free numbers between 1 and {$_} (inclusive) is: ",
    +(1 .. .Int).race.grep: &is-square-free;
}
