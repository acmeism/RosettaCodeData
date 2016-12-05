my $x;
say $x.WHERE;

my $y := $x;   # alias
say $y.WHERE;  # same address as $x

say "Same variable" if $y =:= $x;
$x = 42;
say $y;  # 42
