<?php

$max = 20;
$factor = array(3 => 'Fizz', 5 => 'Buzz', 7 => 'Jazz');

for ($i = 1 ; $i <= $max ; $i++) {
    $matched = false;
    foreach ($factor AS $number => $word) {
        if ($i % $number == 0) {
            echo $word;
            $matched = true;
        }
    }
    echo ($matched ? '' : $i), PHP_EOL;
}

?>
