<?php
// Gamma function

function ln_gamma($z) {
  $lz = array(1.00000000019001, 76.1800917294715, -86.5053203294168,
              24.0140982408309, -1.23173957245015,  0.0012086509738662,
              -0.000005395239385);
  if ($z < 0.5)
    return log(M_PI / sin(M_PI * $z)) - ln_gamma(1.0 - $z);
  else {
    $z -= 1.0;
    $b = $z + 5.5;
    $a = $lz[0];
    for ($i = 1; $i <= 6; $i++)
      $a += $lz[$i] / ($z + $i);
    return (log(sqrt(2 * M_PI)) + log($a) - $b) + log($b) * ($z + 0.5);
  }
}

function gamma($z) {
  return exp(ln_gamma($z));
}

for ($x = 0.1; $x <= 2.05; $x += 0.1)
  echo str_pad(number_format($x, 1, ".", ""), 3, " ", STR_PAD_LEFT)."\t".
    str_pad(number_format(gamma($x), 12, ".", ""), 15, " ", STR_PAD_LEFT).
    PHP_EOL;
?>
