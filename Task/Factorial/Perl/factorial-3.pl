use List::Util qw(reduce);
sub factorial
{
  my $n = shift;
  reduce { $a * $b } 1, 1 .. $n
}
