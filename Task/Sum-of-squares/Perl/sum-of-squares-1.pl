sub sum_of_squares {
  my $sum = 0;
  $sum += $_**2 foreach @_;
  return $sum;
}

print sum_of_squares(3, 1, 4, 1, 5, 9), "\n";
