<?php
function Y($f) {
  $g = create_function('$w', '$f = '.var_export($f,true).';
    return $f(create_function(\'\', \'$w = \'.var_export($w,true).\';
      return call_user_func_array($w($w), func_get_args());
    \'));
  ');
  return $g($g);
}

function almost_fib($f) {
  return create_function('$i', '$f = '.var_export($f,true).';
    return ($i <= 1) ? $i : ($f($i-1) + $f($i-2));
  ');
};
$fibonacci = Y('almost_fib');
echo $fibonacci(10), "\n";

function almost_fac($f) {
  return create_function('$i', '$f = '.var_export($f,true).';
    return ($i <= 1) ? 1 : ($f($i - 1) * $i);
  ');
};
$factorial = Y('almost_fac');
echo $factorial(10), "\n";
?>
