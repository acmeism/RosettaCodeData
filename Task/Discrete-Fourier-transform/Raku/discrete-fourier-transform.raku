sub ft_inner ( @x, $k, $pos_neg_i where * == i|-i ) {
    my @exp := ( $pos_neg_i * tau / +@x * $k ) «*« @x.keys;
    return sum @x »*« 𝑒 «**« @exp;
}
sub dft   ( @x ) { return @x.keys.map: { ft_inner( @x, $_, -i )       } }
sub idft  ( @x ) { return @x.keys.map: { ft_inner( @x, $_,  i ) / +@x } }
sub clean ( @x ) { @x».round(1e-12)».narrow }

my @tests = ( 1, 2-i, -i, -1+2i     ),
            ( 2,   3,  5,     7, 11 ),
;
for @tests -> @x {
    my @x_dft  =  dft(@x);
    my @x_idft = idft(@x_dft);

    say .key.fmt('%6s:'), .value.&clean.fmt('%5s', ', ') for :@x, :@x_dft, :@x_idft;
    say '';
    warn "Round-trip failed" unless ( clean(@x) Z== clean(@x_idft) ).all;
}
