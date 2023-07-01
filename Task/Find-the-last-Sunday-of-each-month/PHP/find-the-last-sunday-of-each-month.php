<?php
// Created with PHP 7.0

function printLastSundayOfAllMonth($year)
{
    $months = array(
        'January', 'February', 'March', 'April', 'June', 'July',
        'August', 'September', 'October', 'November', 'December');

    foreach ($months as $month) {
        echo $month . ': ' . date('Y-m-d', strtotime('last sunday of ' . $month . ' ' . $year)) . "\n";
    }
}

printLastSundayOfAllMonth($argv[1]);
