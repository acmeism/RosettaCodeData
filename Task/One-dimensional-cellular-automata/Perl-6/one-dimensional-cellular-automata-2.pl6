my $size = 10;
my Automata $a .= new:
    :rule(104),
    :cells( 0 xx $size div 2, '111011010101'.comb, 0 xx $size div 2 );
say $a++ for ^10;
