<?php
// Statistics/Normal distribution
normal_stats(100);
echo PHP_EOL;
normal_stats(1000);
echo PHP_EOL;
normal_stats(10000);
echo PHP_EOL;

// Generates normally distributed random numbers with $mean 0 and standard deviation 1
function random_normal() {
  return cos(2.0 * M_PI * mt_rand() / mt_getrandmax()) *
    sqrt(-2.0 * log(mt_rand() / mt_getrandmax()));
}

function normal_stats ($sample_size) {
  if ($sample_size < 1) return;
  srand((double)microtime() * 1000000);
  $r = array_fill(0, $sample_size, 0);
  $h = array_fill(0, 12, 0);
  $sum = 0.0;
  $h_sum = 0;

  // Generate '$sample_size' normally distributed random numbers with $mean 0.5
  // and standard deviation 0.25
  // calculate their $sum
  // and in which box they will fall when drawing the histogram
  for ($i = 0; $i < $sample_size; $i++) {
    $r[$i] = .5 + random_normal() / 4.0;
    $sum += $r[$i];
    if ($r[$i] < 0.0)
      $h[0]++;
    else if ($r[$i] >= 1.0)
      $h[11]++;
    else
      $h[ceil($r[$i] * 10)]++;
  }

  foreach ($h as $h_item)
    $h_sum += $h_item;
  // adjust one of the $h values if necessary to ensure $h_sum = $sample_size
  $adj = $sample_size - $h_sum;
  if ($adj != 0) {
    for ($i = 0; $i <= 11; $i++) {
      $h[$i] += $adj;
      if ($h[$i] >= 0) break;
      $h[$i] -= $adj;
    }
  }
  $mean = $sum / $sample_size;

  $sum = 0.0;
  // Now calculate their standard deviation
  foreach ($r as $r_item)
    $sum += pow($r_item - $mean, 2);
  $sd = sqrt($sum / $sample_size);

  // Draw a histogram of the data with interval 0.1
  // If sample size > 300 then normalize histogram to 300
  $scale = 1.0;
  if ($sample_size > 300)
    $scale = 300.0 / $sample_size;
  echo 'Sample size '.$sample_size.PHP_EOL;
  echo '  Mean '.
    str_pad(number_format($mean, 6, '.', ''), 8, ' ', STR_PAD_LEFT).
    '  SD '.
    str_pad(number_format($sd, 6, '.', ''), 8, ' ', STR_PAD_LEFT).PHP_EOL;
  $i = -1;
  foreach ($h as $h_item) {
    if ($i == -1)
      echo '< 0.00 : ';
    else if ($i == 10)
      echo '>=1.00 : ';
    else
      echo '  '.
        str_pad(number_format($i / 10.0, 2, '.', ''), 4, ' ', STR_PAD_LEFT).
        ' : ';
    echo str_pad($h_item, 5, ' ', STR_PAD_LEFT).' '.
      str_repeat('*', round($h_item * $scale)).PHP_EOL;
    $i++;
  }
}
?>
