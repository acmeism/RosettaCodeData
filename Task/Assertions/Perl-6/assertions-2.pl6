# with a (non-hygienic) macro
macro assert ($x) { "$x or die 'assertion failed: $x'" }
assert('$a == 42');
