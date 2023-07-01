<?php

function max_sum_seq($sequence) {
  // This runs in linear time.
  $sum_start = 0;
  $sum = 0;
  $max_sum = 0;
  $max_start = 0;
  $max_len = 0;
  for ($i = 0; $i < count($sequence); $i += 1) {
    $n = $sequence[$i];
    $sum += $n;
    if ($sum > $max_sum) {
      $max_sum = $sum;
      $max_start = $sum_start;
      $max_len = $i + 1 - $max_start;
    }
    if ($sum < 0) { # start new sequence
      $sum = 0;
      $sum_start = $i + 1;
    }
  }
  return array_slice($sequence, $max_start, $max_len);
}

function print_array($arr) {
  if (count($arr) > 0) {
    echo join(" ", $arr);
  } else {
    echo "(empty)";
  }
  echo '<br>';
}
// tests
print_array(max_sum_seq(array(-1, 0, 15, 3, -9, 12, -4)));
print_array(max_sum_seq(array(-1)));
print_array(max_sum_seq(array(4, -10, 3)));
?>
