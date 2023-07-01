<?php

preg_match_all('/\w+/', file_get_contents($argv[1]), $words);
$frecuency = array_count_values($words[0]);
arsort($frecuency);

echo "Rank\tWord\tFrequency\n====\t====\t=========\n";
$i = 1;
foreach ($frecuency as $word => $count) {
    echo $i . "\t" . $word . "\t" . $count . "\n";
    if ($i >= 10) {
        break;
    }
    $i++;
}
