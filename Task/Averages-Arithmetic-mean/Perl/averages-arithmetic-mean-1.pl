sub avg {
  @_ or return 0;
  my $sum = 0;
  $sum += $_ foreach @_;
  return $sum/@_;
}

print avg(qw(3 1 4 1 5 9)), "\n";
