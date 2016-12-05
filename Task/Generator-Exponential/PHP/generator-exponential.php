<?php
function powers($m) {
    for ($n = 0; ; $n++) {
        yield pow($n, $m);
    }
}

function filtered($s1, $s2) {
    while (true) {
        list($v, $f) = [$s1->current(), $s2->current()];
        if ($v > $f) {
            $s2->next();
            continue;
        } else if ($v < $f) {
            yield $v;
        }
        $s1->next();
    }
}

list($squares, $cubes) = [powers(2), powers(3)];
$f = filtered($squares, $cubes);
foreach (range(0, 19) as $i) {
    $f->next();
}
foreach (range(20, 29) as $i) {
    echo $i, "\t", $f->current(), "\n";
    $f->next();
}
?>
