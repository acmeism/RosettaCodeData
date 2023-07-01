<?php

$attributesTotal = 0;
$count = 0;

while($attributesTotal < 75 || $count < 2) {
    $attributes = [];

    foreach(range(0, 5) as $attribute) {
        $rolls = [];

        foreach(range(0, 3) as $roll) {
            $rolls[] = rand(1, 6);
        }

        sort($rolls);
        array_shift($rolls);

        $total = array_sum($rolls);

        if($total >= 15) {
            $count += 1;
        }

        $attributes[] = $total;
    }

    $attributesTotal = array_sum($attributes);
}

print_r($attributes);
