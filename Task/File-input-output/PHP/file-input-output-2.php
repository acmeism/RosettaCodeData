<?php
if ($contents = file_get_contents('input.txt')) {
    if (!file_put_contents('output.txt', $contents)) {
        echo('Could not write output file.');
    }
} else {
    echo('Could not open input file.');
}
?>
