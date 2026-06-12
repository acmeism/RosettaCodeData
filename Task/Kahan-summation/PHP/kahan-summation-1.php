<?php
// Main task

// 1. Do all arithmetic in decimal to a precision of six digits.
// PHP does not have a way of restricting overall precision

// 2.  Write a function/method/procedure/subroutine/... to perform Kahan
// summation on an ordered collection of numbers, (such as a list of numbers). )
function kahansum($input) {
    $sum = $c = 0;
    foreach($input as $item) {
        $y = $item + $c;
        $t = $sum + $y;
        $c = ($t - $sum) - $y;
        $sum = $t;
    }
    return $sum;
}

// 3. Create the three numbers a, b, c equal to 10000.0, 3.14159, 2.71828
// respectively.
$input = array(10000.0, 3.14159, 2.71828);
list($a, $b, $c) = $input;

// 4. show that the simple left-to-right summation, equivalent to (a + b) + c
// gives an answer of 10005.8 )
$sumabc = ($a + $b) + $c;
echo "Main task - Left to right summation: ";
echo sprintf("%6.1f", $sumabc).PHP_EOL;
// 10005.9

// 5. Show that the Kahan function applied to the sequence of values a, b, c
// results in the more precise answer of 10005.9
echo "Main task - Kahan summation: ";
echo sprintf("%6.1f", kahansum($input)).PHP_EOL;
// 10005.9

// Let's use the substask
$epsilon = 1.0;
while ((1.0 + $epsilon) != 1.0) {
    $epsilon /= 2.0;
}
echo "Trying the subtask".PHP_EOL."epsilon: ";
echo $epsilon.PHP_EOL;
// 1.1102230246252E-16

$a = 1.0;
$b = $epsilon;
$c = -$epsilon;

$input = array($a, $b, $c);

// left-to-right summation
$sumabc = ($a + $b) + $c;
echo "Sub task - Left to right summation: ";
echo sprintf("%.1f", $sumabc).PHP_EOL;

// kahan summation
echo "Sub task - Kahan summation: ";
echo sprintf("%.1f", kahansum($input)).PHP_EOL;

// but, are they really the same or is an artifact?
echo "Are the results the same?".PHP_EOL;
var_dump((($a + $b) + $c) === kahansum($input));

// ok, then what is the difference?
echo "Difference between the operations: ";
$diff = (($a + $b) + $c) - kahansum($input);
echo $diff.PHP_EOL;
