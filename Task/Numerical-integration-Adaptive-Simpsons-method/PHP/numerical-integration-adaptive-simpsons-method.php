<?php
// Numerical integration/Adaptive Simpson's method

function Simpson_rule($f,
                      float $a, float $fa,
                      float $b, float $fb,
                      &$m, &$fm, &$quad_val) {
  $m = ($a + $b) / 2;
  $fm = $f($m);
  $quad_val = (($b - $a) / 6) * ($fa + (4 * $fm) + $fb);
}

function recursion($f,
                   float $a, float $fa,
                   float $b, float $fb,
                   float $tol,
                   float $whole,
                   float $m, float $fm,
                   int $depth): float {
  Simpson_rule($f, $a, $fa, $m, $fm, $lm, $flm, $left);
  Simpson_rule($f, $m, $fm, $b, $fb, $rm, $frm, $right);
  $delta = $left + $right - $whole;
  $tol2 = $tol / 2;
  if ($depth <= 0 || $tol2 == $tol || abs($delta) <= 15 * $tol)
    return $left + $right + ($delta / 15);
  else
    return recursion($f, $a, $fa, $m, $fm, $tol2, $left , $lm, $flm, $depth - 1)
        + recursion($f, $m, $fm, $b, $fb, $tol2, $right, $rm, $frm, $depth - 1);
}

function quad_ASR($f,
                  float $a, float $b,
                  float $tol,
                  int $depth): float {
  $fa = $f($a);
  $fb = $f($b);
  Simpson_rule($f, $a, $fa, $b, $fb, $m, $fm, $whole);
  return recursion($f, $a, $fa, $b, $fb, $tol, $whole, $m, $fm, $depth);
}

$q = quad_ASR('sin', 0, 1, 0.000000001, 1000);
echo 'Estimated definite integral of sin(x) ';
echo 'for x from 0 to 1: '.$q.PHP_EOL;
?>
