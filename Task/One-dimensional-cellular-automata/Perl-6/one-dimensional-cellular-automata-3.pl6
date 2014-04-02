my $size = 50;
my Automata $a .= new: :rule(90), :cells( 0 xx $size div 2, 1, 0 xx $size div 2 );

say $a++ for ^20;
