<?php
for (
    $i = 0;
    $i++ < 100;
    $o = ($i % 3 ? '' : 'Fizz') . ($i % 5 ? '' : 'Buzz')
)
    echo $o ? : $i, PHP_EOL;
?>
