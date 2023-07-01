sub factorial { my $f = 1; $f *= $_ for 2 .. $_[0]; $f; }
sub catalan {
  my $n = shift;
  factorial(2*$n) / factorial($n+1) / factorial($n);
}

print "$_\t@{[ catalan($_) ]}\n" for 0 .. 20;
