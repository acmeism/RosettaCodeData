my @list = 1..10;
say reduce &infix:<+>, @list;
say reduce &infix:<*>, @list;
say reduce &infix:<~>, @list;
say reduce &infix:<min>, @list;
say reduce &infix:<max>, @list;
say reduce &infix:<lcm>, @list;
