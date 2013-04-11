sub sum (Num $x, Num $y) {
	$x += $y;  # ERROR
}

# Explicitly ask for pass-by-reference semantics
sub addto (Num $x is rw, Num $y) {
    $x += $y;  # ok, propagated back to caller
}

# Explicitly ask for pass-by-value semantics
sub sum (Num $x is copy, Num $y) {
    $x += $y;  # ok, but NOT propagated back to caller
    $x;
}
