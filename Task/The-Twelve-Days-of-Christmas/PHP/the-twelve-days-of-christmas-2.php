<?php

$gifts = array(
    'first'    => "A partridge in a pear tree",
    'second'   => "Two turtle doves",
    'third'    => "Three french hens",
    'fourth'   => "Four calling birds",
    'fifth'    => "Five golden rings",
    'sixth'    => "Six geese a-laying",
    'seventh'  => "Seven swans a-swimming",
    'eighth'   => "Eight maids a-milking",
    'ninth'    => "Nine ladies dancing",
    'tenth'    => "Ten lords a-leaping",
    'eleventh' => "Eleven pipers piping",
    'twelfth'  => "Twelve drummers drumming"
);

function print_day( $gifts ) {
    echo "On the ", key( $gifts ), " day of Xmas, my true love gave to me", PHP_EOL;
    foreach( $gifts as $day => $gift ) {
        echo $gift, $day == 'second' ? ' and' : '', PHP_EOL;
    }
    echo PHP_EOL;
}

function twelve_days( $gifts ) {
    if ( ! empty( $gifts ) ) {
        twelve_days( array_slice( $gifts, 1, null, true ) );
        print_day( $gifts );
    }
}

twelve_days( array_reverse( $gifts, true ) );
