<?php

// fputcsv() requires at least PHP 5.1.0
// file "data_in.csv" holds input data
// the result is saved in "data_out.csv"
// this version has no error-checking

$handle = fopen('data_in.csv','r');
$handle_output = fopen('data_out.csv','w');
$row = 0;
$arr = array();

while ($line = fgetcsv($handle))
{
    $arr[] = $line;
}

//change some data to zeroes
$arr[1][0] = 0; // 1,5,9,13,17 => 0,5,9,13,17
$arr[2][1] = 0; // 2,6,10,14,18 => 2,0,10,14,18

//add sum and write file
foreach ($arr as $line)
{
    if ($row==0)
    {
        array_push($line,"SUM");
    }
    else
    {
        array_push($line,array_sum($line));
    }
    fputcsv($handle_output, $line);
    $row++;
}
?>
