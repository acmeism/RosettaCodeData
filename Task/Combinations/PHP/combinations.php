<?php

function combinations_set($set = [], $size = 0) {
    if ($size == 0) {
        return [[]];
    }

    if ($set == []) {
        return [];
    }


    $prefix = [array_shift($set)];

    $result = [];

    foreach (combinations_set($set, $size-1) as $suffix) {
        $result[] = array_merge($prefix, $suffix);
    }

    foreach (combinations_set($set, $size) as $next) {
        $result[] = $next;
    }

    return $result;
}

function combination_integer($n, $m) {
    return combinations_set(range(0, $n-1), $m);
}

assert(combination_integer(5, 3) == [
    [0, 1, 2],
    [0, 1, 3],
    [0, 1, 4],
    [0, 2, 3],
    [0, 2, 4],
    [0, 3, 4],
    [1, 2, 3],
    [1, 2, 4],
    [1, 3, 4],
    [2, 3, 4]
]);

echo "3 comb 5:\n";
foreach (combination_integer(5, 3) as $combination) {
    echo implode(", ", $combination), "\n";
}
