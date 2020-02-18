<?php

$conf = file_get_contents('update-conf-file.txt');

// Disable the needspeeling option (using a semicolon prefix)
$conf = preg_replace('/^(needspeeling)(|\s*\S*)$/mi', '; $1', $conf);

// Enable the seedsremoved option by removing the semicolon and any leading whitespace
$conf = preg_replace('/^;?\s*(seedsremoved)/mi', '$1', $conf);

// Change the numberofbananas parameter to 1024
$conf = preg_replace('/^(numberofbananas)(|\s*\S*)$/mi', '$1 1024', $conf);

// Enable (or create if it does not exist in the file) a parameter for numberofstrawberries with a value of 62000
if (preg_match('/^;?\s*(numberofstrawberries)/mi', $conf, $matches)) {
    $conf = preg_replace('/^(numberofstrawberries)(|\s*\S*)$/mi', '$1 62000', $conf);
} else {
    $conf .= 'NUMBEROFSTRAWBERRIES 62000' . PHP_EOL;
}

echo $conf;
