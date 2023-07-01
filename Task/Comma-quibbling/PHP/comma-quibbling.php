<?php

function quibble($arr){

  $words = count($arr);

  if($words == 0){
    return '{}';
  }elseif($words == 1){
    return '{'.$arr[0].'}';
  }elseif($words == 2){
    return '{'.$arr[0].' and '.$arr[1].'}';
  }else{
    return '{'.implode(', ',  array_splice($arr, 0, -1) ). ' and '.$arr[0].'}';
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
