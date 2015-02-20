sub decimal_to_fraction ( Str $n, Int $rep_digits = 0 ) returns Str {
    my ( $int, $dec ) = ( $n ~~ /^ (\d+) \. (\d+) $/ )».Str or die;

    my ( $numer, $denom ) = ( $dec, 10 ** $dec.bytes );
    if $rep_digits {
        my $to_move = $dec.bytes - $rep_digits;
        $numer -= $dec.substr(0, $to_move);
        $denom -= 10 ** $to_move;
    }

    my $rat = Rat.new( $numer.Int, $denom.Int ).perl;
    return $int ?? "$int $rat" !! $rat;
}

my @a = ['0.9054', 3], ['0.518', 3], ['0.75', 0], (^4).map({['12.34567', $_]});
for @a -> [ $n, $d ] {
    say "$n with $d repeating digits = ", decimal_to_fraction( $n, $d );
}
