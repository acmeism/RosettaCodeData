<?php
$zero = function($f) { return function ($x) { return $x; }; };

$succ = function($n) {
  return function($f) use (&$n) {
    return function($x) use (&$n, &$f) {
      return $f( ($n($f))($x) );
    };
  };
};

$add = function($n, $m) {
  return function($f) use (&$n, &$m) {
    return function($x) use (&$f, &$n, &$m) {
      return ($m($f))(($n($f))($x));
    };
  };
};

$mult = function($n, $m) {
  return function($f) use (&$n, &$m) {
    return function($x) use (&$f, &$n, &$m) {
      return ($m($n($f)))($x);
    };
  };
};

$power = function($b,$e) {
  return $e($b);
};

$to_int = function($f) {
  $count_up = function($i) { return $i+1; };
  return ($f($count_up))(0);
};

$from_int = function($x) {
  $countdown = function($i) use (&$countdown) {
    global $zero, $succ;
    if ( $i == 0 ) {
      return $zero;
    } else {
      return $succ($countdown($i-1));
    };
  };
  return $countdown($x);
};

$three = $succ($succ($succ($zero)));
$four = $from_int(4);
foreach (array($add($three,$four), $mult($three,$four),
	       $power($three,$four), $power($four,$three)) as $ch) {
  print($to_int($ch));
  print("\n");
}
?>
