sub nth-root ($n, $A, $p=1e-9)
{
    my $x0 = $A / $n;
    loop {
        my $x1 = (($n-1) * $x0 + $A / ($x0 ** ($n-1))) / $n;
        return $x1 if abs($x1-$x0) < abs($x0 * $p);
        $x0 = $x1;
    }
}

say nth-root(3,8);
