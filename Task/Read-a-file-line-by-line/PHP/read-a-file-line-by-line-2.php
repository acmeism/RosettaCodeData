<?php // HOW TO ECHO FILE LINE BY LINE FROM THE COMMAND LINE: php5-cli
$file = fopen('test.txt', 'r'); // OPEN FILE WITH READ ACCESS
while (!feof($file)) {
    $line = rtrim(fgets($file)); // REMOVE TRAILING WHITESPACE AND GET LINE
    if($line != NULL) echo("$line\n"); // IF THE LINE ISN'T NULL, ECHO THE LINE
}
