use FiniteField;
$*modulus = 13;

sub f(\x) { x**100 + x + 1};

say f(10);
