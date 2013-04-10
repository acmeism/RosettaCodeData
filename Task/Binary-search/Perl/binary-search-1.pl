sub binary_search {
  ($array_ref, $value, $left, $right) = @_;
  while ($left <= $right) {
    $middle = ($right + $left) / 2;
    if ($array_ref->[$middle] == $value) {
      return 1;
    }
    if ($value < $array_ref->[$middle]) {
      $right = $middle - 1;
    } else {
      $left = $middle + 1;
    }
  }
  return 0;
}
