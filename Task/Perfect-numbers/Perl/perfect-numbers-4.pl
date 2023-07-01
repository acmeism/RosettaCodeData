use ntheory qw/divisor_sum/;
for (1..33550336) {
  print "$_\n" if divisor_sum($_) == 2*$_;
}
