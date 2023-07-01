<?php
function accumulator($sum){
 return function ($x) use (&$sum) { return $sum += $x; };
}
$acc = accumulator(5);
echo $acc(5), "\n"; //prints 10
echo $acc(10), "\n"; //prints 20
?>
