my $x;

$x = 1234;      say $x.WHAT; # (Int) Integer
$x = 12.34;     say $x.WHAT; # (Rat) Rational
$x = 1234e-2;   say $x.WHAT; # (Num) Floating point Number
$x = 1234+i;    say $x.WHAT; # (Complex)
$x = '1234';    say $x.WHAT; # (Str) String
$x = (1,2,3,4); say $x.WHAT; # (List)
$x = [1,2,3,4]; say $x.WHAT; # (Array)
$x = 1 .. 4;    say $x.WHAT; # (Range)
$x = (1 => 2);  say $x.WHAT; # (Pair)
$x = {1 => 2};  say $x.WHAT; # (Hash)
$x = {1, 2};    say $x.WHAT; # (Block)
$x = sub {1};   say $x.WHAT; # (Sub) Code Reference
$x = True;      say $x.WHAT; # (Bool) Boolean
