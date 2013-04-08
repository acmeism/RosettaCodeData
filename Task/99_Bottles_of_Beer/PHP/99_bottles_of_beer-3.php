<?php
$verse = <<<VERSE
100 bottles of beer on the wall,
100 bottles of beer!
Take one down, pass it around!
99 bottles of beer on the wall!


VERSE;

foreach (range(1,99) as $i) { // loop 99 times
    $verse = preg_replace('/\d+/e', '$0 - 1', $verse);
    $verse = preg_replace('/\b1 bottles/', '1 bottle', $verse);
    $verse = preg_replace('/\b0 bottle/', 'No bottles', $verse);

    echo $verse;
}
?>
