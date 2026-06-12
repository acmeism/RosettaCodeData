<?php
// Chebyshev coefficients
const N = 10;
$a = 0.0;
$b = 1.0;
$cheby = array_fill(0, N - 1, 0.0);
$coef = array_fill(0, N - 1, 0.0);
$pi_div_n = M_PI / N;
$b_pl_a_div_2 = ($b + $a) / 2;
$b_mi_a_div_2 = ($b - $a) / 2;
for ($i = 0; $i < N; $i++)
  $coef[$i] = cos(cos($pi_div_n * ($i + 0.5)) * $b_mi_a_div_2 + $b_pl_a_div_2);
for ($i = 0; $i < N; $i++) {
  $w = 0;
  for ($j = 0; $j < N; $j++)
    $w += $coef[$j] * cos($pi_div_n * $i * ($j + 0.5));
  $cheby[$i] = $w * 2. / N;
  echo $i.": ".str_pad(number_format($cheby[$i], 12, ".", ""), 15, " ", STR_PAD_LEFT).PHP_EOL;
}
?>
