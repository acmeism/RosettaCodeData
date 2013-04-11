sub eval_with_x {
    my $code = @_.shift;
    my $x = @_.shift;
    my $first = eval $code;
    $x = @_.shift;
    return eval($code) - $first;
}

print eval_with_x('3 * $x', 5, 10), "\n"; # Prints "15".
