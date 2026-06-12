use v5.36;
use enum    <false true>;
use ntheory <is_prime nth_prime is_semiprime gcd>;

sub comma      { reverse ((reverse shift) =~ s/.{3}\K/,/gr) =~ s/^,//r }
sub table (@V) { my $t = 10 * (my $w = 5); ( sprintf( ('%'.$w.'d')x@V, @V) ) =~ s/.{1,$t}\K/\n/gr }

sub find_factor ($n, $constant = 1) {   # NB: required that n > 1
    my($x, $rho, $factor) = (2, 1, 1);
    while ($factor == 1) {
        $rho *= 2;
        my $fixed = $x;
        for (0..$rho) {
            $x = ( $x * $x + $constant ) % $n;
            $factor = gcd(($x-$fixed), $n);
            last if 1 < $factor;
        }
    }
    $factor = find_factor($n, $constant+1) if $n == $factor;
    $factor
}

# Call with range 1..$limit
sub is_mpn($n) {
    state $cube = 1; $cube = 1 if $n == 1; # set and reset
    $n == 1 ? return true : is_prime($n) ? return false : ();
    ++$cube, return true if $n == nth_prime($cube)**3;
    my $factor = find_factor($n);
    my $div    = int $n/$factor;
    return true if is_prime $factor and is_prime $div and $div != $factor;
    false
}

say "Multiplicatively perfect numbers less than 500:\n" . table grep is_mpn($_), 1..499;

say 'There are:';
for my $limit (5e2, 5e3, 5e4, 5e5, 5e6) {
    my($m,$s) = (0,0);
    is_mpn       $_ and $m++ for 1..$limit-1;
    is_semiprime $_ and $s++ for 1..$limit-1;
    printf "%8s MPNs less than %8s, %8s semiprimes\n", comma($m), $limit, comma $s
}
