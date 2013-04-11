sub infix:<bsr>( $a, $b, :$rotate, :$unsigned ) {
    if $rotate {
        my $INTSIZE = $*VM{'config'}{'intvalsize'} * 8; # hack to get native Int size
        my $c = $b % $INTSIZE;
        return pir::lsr__III($a, $c) +| pir::shl__III((2**$c-1) +& $a, $INTSIZE-$c);
    }
    if $unsigned {
        return pir::lsr__III($a, $b);
    }
    pir::shr__III($a, $b);
}

sub infix:<bsl>( $a, $b, :$rotate, :$unsigned ) {
    if $rotate {
        my $INTSIZE = $*VM{'config'}{'intvalsize'} * 8; # hack to get native Int size
        my $c = $b % $INTSIZE;
        return pir::shl__III($a, $c) +| pir::lsr__III($a, $INTSIZE-$c);
    }
    pir::shl__III($a, $b);
}

bs_int(7,2);

sub bs_int ($a, $b) {
    say_bit "$a Signed Bit shift right $b", $a bsr $b;
    say_bit "$a Unsigned Bit shift right $b", infix:<bsr>($a,  $b, :unsigned);
    say_bit "$a Rotate right $b", infix:<bsr>($a, $b, :rotate);
    say_bit "$a Bit shift left $b", $a bsl $b;
    say_bit "$a Rotate left $b", infix:<bsl>($a, $b, :rotate);
}
