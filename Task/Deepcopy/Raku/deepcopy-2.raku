my %x = foo => 0, bar => [0, 1];
my %y = %x.raku.EVAL;

%x<bar>[1]++;
say %x;
say %y;
