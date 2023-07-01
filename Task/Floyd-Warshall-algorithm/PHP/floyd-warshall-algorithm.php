<?php
$graph = array();
for ($i = 0; $i < 10; ++$i) {
    $graph[] = array();
    for ($j = 0; $j < 10; ++$j)
        $graph[$i][] = $i == $j ? 0 : 9999999;
}

for ($i = 1; $i < 10; ++$i) {
    $graph[0][$i] = $graph[$i][0] = rand(1, 9);
}

for ($k = 0; $k < 10; ++$k) {
    for ($i = 0; $i < 10; ++$i) {
        for ($j = 0; $j < 10; ++$j) {
            if ($graph[$i][$j] > $graph[$i][$k] + $graph[$k][$j])
                $graph[$i][$j] = $graph[$i][$k] + $graph[$k][$j];
        }
    }
}

print_r($graph);
?>
