use ntheory qw/factor is_prime trial_factor/;
sub issemi {
  my $n = shift;
  if ((my @p = trial_factor($n,500)) > 1) {
    return 0 if @p > 2;
    return !!is_prime($p[1]) if @p == 2;
  }
  2 == factor($n);
}
