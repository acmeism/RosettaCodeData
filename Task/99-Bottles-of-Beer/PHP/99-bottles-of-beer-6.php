<?php

$lyrics = <<<ENDVERSE
%2\$d bottle%1\$s of beer on the wall
%2\$d bottle%1\$s of beer
Take one down, pass it around
%4\$s bottle%3\$s of beer on the wall


ENDVERSE;

$x = 99;
while ( $x > 0 ) {
   printf( $lyrics, $x != 1 ? 's' : '', $x--, $x != 1 ? 's' : '', $x > 0 ? $x : 'No more' );
}
