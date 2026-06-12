use ntheory qw(forcomb);
use Math::Cartesian::Product;

$n = 17;
push @a, [(0) x $n] for 0..$n-1;
$a[$_][$_] = '-' for 0..$n-1;

for $x (cartesian {@_} [(0..$n-1)], [(1,2,4,8)]) {
    $i = @$x[0];
    $k = @$x[1];
    $j = ($i + $k) % $n;
    $a[$i][$j] = $a[$j][$i] = 1;
}

forcomb {
    my $l = 0;
    @i = @_;
    forcomb { $l += $a[ $i[$_[0]] ][ $i[$_[1]] ]; } (4,2);
    die "Bogus!" unless 0 < $l and $l < 6;
} ($n,4);

print join(' ' ,@$_) . "\n" for @a;
print 'OK'
