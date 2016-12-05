use MONKEY-SEE-NO-EVAL;

my ($a, $b) = (-5, 7);
my $ans = EVAL 'abs($a * $b)';  # => 35
