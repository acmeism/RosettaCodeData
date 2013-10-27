<?php
floyds_triangle(5);
floyds_triangle(14);

function floyds_triangle($n) {
    echo "n = " . $n . "\r\n";
    $count = 1;
    for ($i = $n; $i > 0; $i--) {

        for ($j = $i; $j < $n + 1; $j++) {
           printf("%4s", $count);
            $count++;
        }
  echo "\r\n";
    }
?>
