<?php
// Statistics/Basic
basic_stats(100);
echo PHP_EOL;
basic_stats(1000);
echo PHP_EOL;
basic_stats(10000);
echo PHP_EOL;

function basic_stats (int $sample_size) {
  if ($sample_size < 1) return;
  srand((double)microtime() * 1000000);
  $r = array_fill(0, $sample_size, 0);
  $h = array_fill(0, 10, 0);
  $sum = 0.0;
  $h_sum = 0;

  // Generate '$sample_size' normally distributed random numbers with $mean 0.5
  // and standard deviation 0.25
  // calculate their $sum
  // and in which box they will fall when drawing the histogram
  for ($i = 0; $i < $sample_size; $i++) {
    $r[$i] = mt_rand() / mt_getrandmax();
    $sum += $r[$i];
    $h[floor($r[$i] * 10)]++;
  }

  foreach ($h as $h_item)
    $h_sum += $h_item;
  // adjust one of the $h values if necessary to ensure $h_sum = $sample_size
  $adj = $sample_size - $h_sum;
  if ($adj != 0) {
    for ($i = 0; $i < 10; $i++) {
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
  if ($sample_size > 500)
    $scale = 500.0 / $sample_size;
  echo 'Sample size '.$sample_size.PHP_EOL;
  echo '  Mean '.
    str_pad(number_format($mean, 6, '.', ''), 8, ' ', STR_PAD_LEFT).
    '  SD '.
    str_pad(number_format($sd, 6, '.', ''), 8, ' ', STR_PAD_LEFT).PHP_EOL;
  $i = 0;
  foreach ($h as $h_item) {
    echo '  '.
        str_pad(number_format($i / 10.0, 2, '.', ''), 4, ' ', STR_PAD_LEFT).
        ' : ';
    echo str_pad($h_item, 5, ' ', STR_PAD_LEFT).' '.
      str_repeat('*', round($h_item * $scale)).PHP_EOL;
    $i++;
  }
}
?>
