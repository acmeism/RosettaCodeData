<?php
function A($k,$x1,$x2,$x3,$x4,$x5) {
  static $i = 0;
  $b = "myfunction_$i";
  $i++;
  eval('function '.$b.'() {
    static $k = '.$k.';
    return A(--$k, '.var_export($b,true).',
             '.var_export($x1,true).',
             '.var_export($x2,true).',
             '.var_export($x3,true).',
             '.var_export($x4,true).');
  }');
  return $k <= 0 ? $x4() + $x5() : $b();
}

echo A(10, create_function('', 'return  1;'),
           create_function('', 'return -1;'),
           create_function('', 'return -1;'),
           create_function('', 'return  1;'),
           create_function('', 'return  0;')) . "\n";
?>
