<?php
$file = fopen(__FILE__, 'r'); // read current file
while ($line = fgets($file)) {
    $line = rtrim($line);      // removes linebreaks and spaces at end
    echo strrev($line) . "\n"; // reverse line and upload it
}
