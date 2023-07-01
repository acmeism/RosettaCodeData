sub div($a, $b) {
    my $r;
    try {
        $r = $a / $b;
        CATCH {
            default { note "Unexpected exception, $_" }
        }
    }
    return $r // Nil;
}
say div(10,2);
say div(1, sin(0));
