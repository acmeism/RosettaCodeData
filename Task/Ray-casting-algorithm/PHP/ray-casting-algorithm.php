<?php

function contains($bounds, $lat, $lng)
{
    $count = 0;
    $bounds_count = count($bounds);
    for ($b = 0; $b < $bounds_count; $b++) {
        $vertex1 = $bounds[$b];
        $vertex2 = $bounds[($b + 1) % $bounds_count];
        if (west($vertex1, $vertex2, $lng, $lat))
            $count++;
    }

    return $count % 2;
}

function west($A, $B, $x, $y)
{
    if ($A['y'] <= $B['y']) {
        if ($y <= $A['y'] || $y > $B['y'] ||
            $x >= $A['x'] && $x >= $B['x']) {
            return false;
        }
        if ($x < $A['x'] && $x < $B['x']) {
            return true;
        }
        if ($x == $A['x']) {
            if ($y == $A['y']) {
                $result1 = NAN;
            } else {
                $result1 = INF;
            }
        } else {
            $result1 = ($y - $A['y']) / ($x - $A['x']);
        }
        if ($B['x'] == $A['x']) {
            if ($B['y'] == $A['y']) {
                $result2 = NAN;
            } else {
                $result2 = INF;
            }
        } else {
            $result2 = ($B['y'] - $A['y']) / ($B['x'] - $A['x']);
        }
        return $result1 > $result2;
    }

    return west($B, $A, $x, $y);
}

$square = [
    'name' => 'square',
    'bounds' => [['x' => 0, 'y' => 0], ['x' => 20, 'y' => 0], ['x' => 20, 'y' => 20], ['x' => 0, 'y' => 20]]
];
$squareHole = [
    'name' => 'squareHole',
    'bounds' => [['x' => 0, 'y' => 0], ['x' => 20, 'y' => 0], ['x' => 20, 'y' => 20], ['x' => 0, 'y' => 20], ['x' => 5, 'y' => 5], ['x' => 15, 'y' => 5], ['x' => 15, 'y' => 15], ['x' => 5, 'y' => 15]]
];
$strange = [
    'name' => 'strange',
    'bounds' => [['x' => 0, 'y' => 0], ['x' => 5, 'y' => 5], ['x' => 0, 'y' => 20], ['x' => 5, 'y' => 15], ['x' => 15, 'y' => 15], ['x' => 20, 'y' => 20], ['x' => 20, 'y' => 0]]
];
$hexagon = [
    'name' => 'hexagon',
    'bounds' => [['x' => 6, 'y' => 0], ['x' => 14, 'y' => 0], ['x' => 20, 'y' => 10], ['x' => 14, 'y' => 20], ['x' => 6, 'y' => 20], ['x' => 0, 'y' => 10]]
];

$shapes = [$square, $squareHole, $strange, $hexagon];

$testPoints = [
    ['lng' => 10, 'lat' => 10],
    ['lng' => 10, 'lat' => 16],
    ['lng' => -20, 'lat' => 10],
    ['lng' => 0, 'lat' => 10],
    ['lng' => 20, 'lat' => 10],
    ['lng' => 16, 'lat' => 10],
    ['lng' => 20, 'lat' => 20]
];

for ($s = 0; $s < count($shapes); $s++) {
    $shape = $shapes[$s];
    for ($tp = 0; $tp < count($testPoints); $tp++) {
        $testPoint = $testPoints[$tp];
        echo json_encode($testPoint) . "\tin " . $shape['name'] . "\t" . contains($shape['bounds'], $testPoint['lat'], $testPoint['lng']) . PHP_EOL;
    }
}
