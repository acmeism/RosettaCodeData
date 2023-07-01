<?php
$plural = 's';
foreach (range(99, 1) as $i) {
    echo "$i bottle$plural of beer on the wall,\n";
    echo "$i bottle$plural of beer!\n";
    echo "Take one down, pass it around!\n";
    if ($i - 1 == 1)
        $plural = '';

    if ($i > 1)
        echo ($i - 1) . " bottle$plural of beer on the wall!\n\n";
    else
        echo "No more bottles of beer on the wall!\n";
}
?>
