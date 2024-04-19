<?php

function quibble($arr) {

    switch (count($arr)) {

        case 0:
            return '{}';

        case 1:
            return "{{$arr[0]}}";

        default:
            $left = implode(', ', array_slice($arr, 0, -1));
            $right = array_slice($arr, -1)[0];
            return "{{$left} and {$right}}";

    }

}


$tests = [
  [],
  ["ABC"],
  ["ABC", "DEF"],
  ["ABC", "DEF", "G", "H"]
];

foreach ($tests as $test) {
  echo quibble($test) . PHP_EOL;
}
?>
