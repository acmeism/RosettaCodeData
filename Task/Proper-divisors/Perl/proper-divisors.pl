use ntheory qw/divisors/;
sub proper_divisors {
  my $n = shift;
  # Like Pari/GP, divisors(0) = (0,1) and divisors(1) = ()
  return 1 if $n == 0;
  my @d = divisors($n);
  pop @d;  # divisors are in sorted order, so last entry is the input
  @d;
}
say "$_: ", join " ", proper_divisors($_) for 1..10;
# 1. For the max, we can do a traditional loop.
my($max,$ind) = (0,0);
for (1..20000) {
  my $nd = scalar proper_divisors($_);
 ($max,$ind) = ($nd,$_) if $nd > $max;
}
say "$max $ind";
# 2. Or we can use List::Util's max with decoration (this exploits its implementation)
{
  use List::Util qw/max/;
  no warnings 'numeric';
  say max(map { scalar(proper_divisors($_)) . " $_" } 1..20000);
}
