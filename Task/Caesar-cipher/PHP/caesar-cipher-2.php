<?php

function caesarEncode($message, $key) {
    $from = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    $to   = substr($from, $key) . substr($from, 0, $key);
    return strtr($message, $from, $to);
}

echo caesarEncode('THE QUICK BROWN FOX JUMPED OVER THE LAZY DOG', 12), PHP_EOL;
