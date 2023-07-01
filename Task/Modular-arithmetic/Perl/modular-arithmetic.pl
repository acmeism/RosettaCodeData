use Math::ModInt qw(mod);
sub f { my $x = shift; $x**100 + $x + 1 };
print f mod(10, 13);
