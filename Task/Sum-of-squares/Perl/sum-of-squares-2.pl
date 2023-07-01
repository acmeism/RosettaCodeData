use List::Util qw(reduce);
sub sum_of_squares {
  reduce { $a + $b **2 } 0, @_;
}

print sum_of_squares(3, 1, 4, 1, 5, 9), "\n";
