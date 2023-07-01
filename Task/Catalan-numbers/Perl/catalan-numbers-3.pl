use ntheory qw/binomial/;
sub catalan {
  my $n = shift;
  binomial(2*$n,$n)/($n+1);
}
print "$_\t", catalan($_), "\n" for 0 .. 10000;
