use MONKEY-SEE-NO-EVAL;

my %x = foo => 0, bar => [0, 1];
my %y = %x.perl.EVAL;

%x<bar>[1]++;
say %x;
say %y;
