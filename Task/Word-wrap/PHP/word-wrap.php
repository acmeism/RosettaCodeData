<?php

$text = <<<ENDTXT
If there's anything you need
All you have to do is say
You know you satisfy everything in me
We shouldn't waste a single day

So don't stop me falling
It's destiny calling
A power I just can't deny
It's never changing
Can't you hear me, I'm saying
I want you for the rest of my life

Together forever and never to part
Together forever we two
And don't you know
I would move heaven and earth
To be together forever with you
ENDTXT;

// remove preexisting line breaks
$text = str_replace( PHP_EOL,  " " , $text );

echo wordwrap( $text, 20 ), PHP_EOL, PHP_EOL;

echo wordwrap( $text, 40 ), PHP_EOL, PHP_EOL;

echo wordwrap( $text, 80 ), PHP_EOL, PHP_EOL;
