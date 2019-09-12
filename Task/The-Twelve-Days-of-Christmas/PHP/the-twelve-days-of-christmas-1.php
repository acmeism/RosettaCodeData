<?php

header("Content-Type: text/plain; charset=UTF-8");

$days = array(
    'first', 'second', 'third', 'fourth', 'fifth', 'sixth', 'seventh', 'eighth', 'ninth',
    'tenth', 'eleventh', 'twelfth',
);

$gifts = array(
    "A partridge in a pear tree",
    "Two turtle doves",
    "Three french hens",
    "Four calling birds",
    "Five golden rings",
    "Six geese a-laying",
    "Seven swans a-swimming",
    "Eight maids a-milking",
    "Nine ladies dancing",
    "Ten lords a-leaping",
    "Eleven pipers piping",
    "Twelve drummers drumming"
);

$verses = [];

for ( $i = 0; $i < 12; $i++ ) {
    $lines = [];
    $lines[0] = "On the {$days[$i]} day of Christmas, my true love gave to me";

    $j = $i;
    $k = 0;
    while ( $j >= 0 ) {
        $lines[++$k] = $gifts[$j];
        $j--;
    }

    $verses[$i] = implode(PHP_EOL, $lines);

    if ( $i == 0 )
        $gifts[0] = "And a partridge in a pear tree";
}

echo implode(PHP_EOL . PHP_EOL, $verses);

?>
