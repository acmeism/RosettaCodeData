<?php

function main() {
    $maximumArea = 1000;
    $halfMaximumArea = $maximumArea / 2;

    $ohalloranNumbers = array_fill(0, $halfMaximumArea, true);

    for ($length = 1; $length < $maximumArea; $length++) {
        for ($width = 1; $width < $halfMaximumArea; $width++) {
            for ($height = 1; $height < $halfMaximumArea; $height++) {
                $halfArea = $length * $width + $length * $height + $width * $height;

                if ($halfArea < $halfMaximumArea) {
                    $ohalloranNumbers[$halfArea] = false;
                }
            }
        }
    }

    echo "Values larger than 6 and less than $maximumArea which cannot be the surface area of a cuboid:\n";
    for ($i = 3; $i < $halfMaximumArea; $i++) {
        if ($ohalloranNumbers[$i]) {
            echo ($i * 2) . " ";
        }
    }
    echo "\n";
}

main();

?>
