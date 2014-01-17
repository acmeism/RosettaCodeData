sub binary_search {
  my ($array_ref, $value, $left, $right) = @_;
  if ($right < $left) {
    return 0;
  }
  my $middle = int(($right + $left) / 2);
  if ($array_ref->[$middle] == $value) {
    return 1;
  }
  if ($value < $array_ref->[$middle]) {
    binary_search($array_ref, $value, $left, $middle - 1);
  } else {
    binary_search($array_ref, $value, $middle + 1, $right);
  }
}
