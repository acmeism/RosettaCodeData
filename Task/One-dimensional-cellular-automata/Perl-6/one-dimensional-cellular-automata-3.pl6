my @padding = 0 xx 25;
my Automaton $a .= new: :rule(90), :cells(flat @padding, 1, @padding);

say $a++ for ^20;
