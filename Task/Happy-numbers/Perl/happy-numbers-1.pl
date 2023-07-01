use List::Util qw(sum);

sub ishappy {
  my $s = shift;
  while ($s > 6 && $s != 89) {
    $s = sum(map { $_*$_ } split(//,$s));
  }
  $s == 1;
}

my $n = 0;
print join(" ", map { 1 until ishappy(++$n); $n; } 1..8), "\n";
