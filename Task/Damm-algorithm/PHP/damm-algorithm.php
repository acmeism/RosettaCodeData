<?php
function lookup($r,$c) {
    $table = array(
        array(0, 3, 1, 7, 5, 9, 8, 6, 4, 2),
        array(7, 0, 9, 2, 1, 5, 4, 8, 6, 3),
        array(4, 2, 0, 6, 8, 7, 1, 3, 5, 9),
        array(1, 7, 5, 0, 9, 8, 3, 4, 2, 6),
        array(6, 1, 2, 3, 0, 4, 5, 9, 7, 8),
        array(3, 6, 7, 4, 2, 0, 9, 5, 8, 1),
        array(5, 8, 6, 9, 7, 2, 0, 1, 3, 4),
        array(8, 9, 4, 5, 3, 6, 2, 0, 1, 7),
        array(9, 4, 3, 8, 6, 1, 7, 2, 0, 5),
        array(2, 5, 8, 1, 4, 3, 6, 7, 9, 0),
    );
    return $table[$r][$c];
}

function isDammValid($input) {
    return array_reduce(str_split($input), "lookup", 0) == 0;
}

foreach(array("5724", "5727", "112946", "112949") as $i) {
    echo "{$i} is ".(isDammValid($i) ? "valid" : "invalid")."<br>";
}
?>
