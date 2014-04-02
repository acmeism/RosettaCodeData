my $a = (1..100).pick;

# with a (non-hygienic) macro
macro assert ($x) { "$x or die 'assertion failed: $x'" }
assert('$a == 42');

# but usually we just say
$a == 42 or die '$a ain\'t 42';
