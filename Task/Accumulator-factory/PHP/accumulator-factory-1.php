<?php
function accumulator($start){
 return create_function('$x','static $v='.$start.';return $v+=$x;');
}
$acc = accumulator(5);
echo $acc(5), "\n"; //prints 10
echo $acc(10), "\n"; //prints 20
?>
