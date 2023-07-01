use v5.36;
use ntheory 'divisors';
use enum qw(False True);
use List::AllUtils <firstidx sum>;

sub proper_divisors ($n) {
  return 1 if $n == 0;
  my @d = divisors($n);
  pop @d;
  @d;
}

sub is_Erdos_Nicolas ($n) {
    my @divisors = proper_divisors($n);
    return False unless sum(@divisors) > $n;
    my $sum;
    my $key = firstidx { $_ == $n } map { $sum += $_ } @divisors;
    $key ? 1 + $key : False;
}

my($n,$count) = (2,0);
until ($count == 8) {
    next unless 0 == ++$n % 2;
    if (my $key = is_Erdos_Nicolas $n) {
        printf "%8d == sum of its first %3d divisors\n", $n, $key;
        $count++
    }
}
