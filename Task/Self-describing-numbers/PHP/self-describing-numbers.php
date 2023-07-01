<?php

function is_describing($number) {
    foreach (str_split((int) $number) as $place => $value) {
        if (substr_count($number, $place) != $value) {
            return false;
        }
    }
    return true;
}

for ($i = 0; $i <= 50000000; $i += 10) {
    if (is_describing($i)) {
        echo $i . PHP_EOL;
    }
}

?>
