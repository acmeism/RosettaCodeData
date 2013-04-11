<?php
function Y($f) {
  $g = function($w) use($f) {
    return $f(function() use($w) {
      return call_user_func_array($w($w), func_get_args());
    });
  };
  return $g($g);
}

$fibonacci = Y(function($f) {
  return function($i) use($f) { return ($i <= 1) ? $i : ($f($i-1) + $f($i-2)); };
});

echo $fibonacci(10), "\n";

$factorial = Y(function($f) {
  return function($i) use($f) { return ($i <= 1) ? 1 : ($f($i - 1) * $i); };
});

echo $factorial(10), "\n";
?>
