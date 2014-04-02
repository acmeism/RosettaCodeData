sub ethiopic-mult {
    my &halve  = * div= 2;
    my &double = * *= 2;
    my &even   = * %% 2;

    my ($a,$b) = @_;
    my $r;
    loop {
        even  $a or $r += $b;
        halve $a or return $r;
        double $b;
    }
}

say ethiopic-mult(17,34);
