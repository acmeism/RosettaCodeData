constant p = 1.32471795724474602596;
constant s = 1.0453567932525329623;
constant %rules = A => 'B', B => 'C', C => 'AB';

my @pad-recur = 1, 1, 1, -> $c, $b, $ { $b + $c }  … *;

my @pad-floor = { floor 1/2 + p ** ($++ - 1) / s } … *;

my @pad-L-sys = 'A', { %rules{$^axiom.comb}.join } … *;
my @pad-L-len = @pad-L-sys.map: *.chars;

say @pad-recur.head(20);
say @pad-L-sys.head(10);

say "Recurrence == Floor to N=64" if (@pad-recur Z== @pad-floor).head(64).all;
say "Recurrence == L-len to N=32" if (@pad-recur Z== @pad-L-len).head(32).all;
