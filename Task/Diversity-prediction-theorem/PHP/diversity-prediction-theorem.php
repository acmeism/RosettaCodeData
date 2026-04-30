<?php
// Diversity prediction theorem

$estims = array(array(48.0, 47.0, 51.0, 0.0),
                array(48.0, 47.0, 51.0, 42.0, 0.0));
$true_val = 49.0;
for ($i = 0; $i <= 1; $i++) {
  $sum = 0.0;
  $j = 0;
  while ($estims[$i][$j] != 0) {
    $sum += pow($estims[$i][$j] - $true_val, 2);
    $j++;
  }
  $avg_err = $sum / $j;
  echo 'Average error : '.
      str_pad(number_format($avg_err, 3, '.', ''), 7, ' ', STR_PAD_LEFT);
  $sum = 0;
  $j = 0;
  while ($estims[$i][$j] != 0) {
    $sum += $estims[$i][$j];
    $j++;
  }
  $avg = $sum / $j;
  $crowd_err = pow($true_val - $avg, 2);
  echo PHP_EOL;
  echo 'Crowd error   : '.
      str_pad(number_format($crowd_err, 3, '.', ''), 7, ' ', STR_PAD_LEFT).
      PHP_EOL;
  echo 'Diversity     : '.
      str_pad(number_format($avg_err - $crowd_err, 3, '.', ''), 7, ' ', STR_PAD_LEFT).
      PHP_EOL.PHP_EOL;
}
?>
