use ntheory ":all";

sub prime_partition {
  my($num, $parts) = @_;
  return is_prime($num) ? [$num] : undef if $parts == 1;
  my @p = @{primes($num)};
  my $r;
  forcomb { lastfor, $r = [@p[@_]] if vecsum(@p[@_]) == $num; } @p, $parts;
  $r;
}

foreach my $test ([18,2], [19,3], [20,4], [99807,1], [99809,1], [2017,24], [22699,1], [22699,2], [22699,3], [22699,4], [40355,3]) {
  my $partar = prime_partition(@$test);
  printf "Partition %5d into %2d prime piece%s %s\n", $test->[0], $test->[1], ($test->[1] == 1) ? ": " : "s:", defined($partar) ? join("+",@$partar) : "not possible";
}
