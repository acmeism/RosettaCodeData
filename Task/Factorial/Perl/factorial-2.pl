sub factorial
{
  my $n = shift;
  ($n == 0)? 1 : $n*factorial($n-1);
}
