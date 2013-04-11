sub factorial
{
  my $n = shift;
  my $result = 1;
  for (my $i = 1; $i <= $n; ++$i)
  {
    $result *= $i;
  };
  $result;
}

# using a .. range
sub factorial {
    my $r = 1;
    $r *= $_ for 1..shift;
    $r;
}
