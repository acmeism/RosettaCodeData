<?php

if (!$in = fopen('input.txt', 'r')) {
    die('Could not open input file.');
}

if (!$out = fopen('output.txt', 'w')) {
    die('Could not open output file.');
}

while (!feof($in)) {
    $data = fread($in, 512);
    fwrite($out, $data);
}

fclose($out);
fclose($in);
?>
