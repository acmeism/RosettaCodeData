<?php

define('WIDTH',      10);
define('HEIGHT',     10);

define('GEN_CNT',    10);
define('PAUSE',  250000);

define('TREE_PROB',  50);
define('GROW_PROB',   5);
define('FIRE_PROB',   1);

define('BARE',      ' ');
define('TREE',      'A');
define('BURN',      '/');


$forest = makeNewForest();

for ($i = 0; $i < GEN_CNT; $i++) {
    displayForest($forest, $i);
    $forest = getNextForest($forest);
}

displayForest($forest, 'done');
exit;


function makeNewForest() {
    return mapForest([
        'func' => function(){
            return isProb(TREE_PROB) ? TREE : BARE;
        }
    ]);
}


function displayForest($forest, $generationNum) {
    system("clear");
    echo PHP_EOL . "Generation: $generationNum" . PHP_EOL;
    mapForest(['forest' => $forest, 'func' => function($f, $x, $y){
            echo $f[$y][$x] . ($x == WIDTH - 1 ? PHP_EOL : '');
        }
    ]);
    echo PHP_EOL;
    usleep(PAUSE);
}


function getNextForest($oldForest) {
    return mapForest(['forest' => $oldForest, 'func' => function($f, $x, $y){
            switch ($f[$y][$x]) {
                case BURN:
                    return BARE;
                case BARE:
                    return isProb(GROW_PROB) ? TREE : BARE;
                case TREE:
                    $caughtFire = isProb(FIRE_PROB);
                    $ablaze = $caughtFire ? true : getNumBurningNeighbors($f, $x, $y) > 0;
                return $ablaze ? BURN : TREE;
            }
        }
    ]);
}


function getNumBurningNeighbors($forest, $x, $y) {
    $burningNeighbors = mapForest([
        'forest' => $forest,
        'x1' => $x - 1, 'x2' => $x + 2,
        'y1' => $y - 1, 'y2' => $y + 2,
        'default' => 0,
        'func' => function($f, $x, $y){
            return $f[$y][$x] == BURN ? 1 : 0;
        }
    ]);

    $numOnFire = 0;
    foreach ($burningNeighbors as $row) {
        $numOnFire += array_sum($row);
    }
    return $numOnFire;
}


function mapForest($params) {
    $p = array_merge([
        'forest' => [],
        'func' => function(){echo "default\n";},
        'x1' => 0,
        'x2' => WIDTH,
        'y1' => 0,
        'y2' => HEIGHT,
        'default' => BARE
    ], $params);

    $newForest = [];
    for ($y = $p['y1']; $y < $p['y2']; $y++) {
        $newRow = [];
        for ($x = $p['x1']; $x < $p['x2']; $x++) {
            $inBounds = ($x >= 0 && $x < WIDTH && $y >= 0 && $y < HEIGHT);
            $newRow[] = ($inBounds ? $p['func']($p['forest'], $x, $y) : $p['default']);
        }
        $newForest[] = $newRow;
    }
    return $newForest;
}


function isProb($prob) {
    return rand(0, 100) < $prob;
}
