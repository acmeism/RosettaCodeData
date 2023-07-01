sub fib_iter {
  my $n = shift;
  use bigint try => "GMP,Pari";
  my ($v2,$v1) = (-1,1);
  ($v2,$v1) = ($v1,$v2+$v1) for 0..$n;
  $v1;
}
