use v5.36;
use enum <false true>;
use ntheory <is_prime gcd>;

sub comma { reverse ((reverse shift) =~ s/.{3}\K/,/gr) =~ s/^,//r }
sub table ($c, @V) { my $t = $c * (my $w = 5); ( sprintf( ('%'.$w.'d')x@V, @V) ) =~ s/.{1,$t}\K/\n/gr }

sub is_blum ($n) {
    return false if $n < 2 or is_prime $n;
    my $factor = find_factor($n);
    my $div = int($n / $factor);
    return true if is_prime($factor) && is_prime($div) && ($div != $factor) && ($factor%4 == 3) && ($div%4 == 3);
    false;
}

sub find_factor ($n, $constant = 1) {
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
    $factor;
}

my($i, @blum, %C);
my @nth = (26828, 1e5, 2e5, 3e5, 4e5);

while (++$i) {
    push @blum, $i if is_blum $i;
    last if $nth[-1] == scalar @blum;
}
$C{substr $_, -1, 1}++ for @blum;

say "The first fifty Blum integers:\n" . table 10, @blum[0..49];
printf "The %7sth Blum integer: %9s\n", comma($_), comma $blum[$_-1] for @nth;
say '';
printf "$_: %6d (%.3f%%)\n", $C{$_}, 100*$C{$_}/scalar @blum for <1 3 7 9>;
