sub fib (Int $n --> Int) {
    $n > 1 or return $n;
    my ($prev, $this) = 0, 1;
    ($prev, $this) = $this, $this + $prev for 1 ..^ $n;
    return $this;
}
