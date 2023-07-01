<?php
function encode($str)
{
    return preg_replace_callback('/(.)\1*/', function ($match) {
        return strlen($match[0]) . $match[1];
    }, $str);
}

function decode($str)
{
    return preg_replace_callback('/(\d+)(\D)/', function($match) {
        return str_repeat($match[2], $match[1]);
    }, $str);
}

echo encode('WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW'), PHP_EOL;
echo decode('12W1B12W3B24W1B14W'), PHP_EOL;
?>
