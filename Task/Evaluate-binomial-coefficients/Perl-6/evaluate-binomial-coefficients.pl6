multi sub postfix:<!>(Int $a) {
    [*] 1..$a;
}

sub binomialcoefficient($n, $k) {
    $n! / (($n - $k)! * $k!);
}

say binomialcoefficient(5, 3);
