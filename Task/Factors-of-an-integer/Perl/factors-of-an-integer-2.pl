sub factors {
  my $n = shift;
  $n = -$n if $n < 0;
  my @divisors;
  for (1 .. int(sqrt($n))) {  # faster and less memory than map/grep
    push @divisors, $_ unless $n % $_;
  }
  # Return divisors including top half, without duplicating a square
  @divisors, map { $_*$_ == $n ? () : int($n/$_) } reverse @divisors;
}
print join " ", factors(64), "\n";
