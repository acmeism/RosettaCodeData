my @padding = 0 xx 5;
my Automaton $a .= new:
    rule  => 104,
    cells => flat @padding, '111011010101'.comb, @padding
;
say $a++ for ^10;
