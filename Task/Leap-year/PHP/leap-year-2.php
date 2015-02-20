<?php
function isLeapYear($year) {
    return (date('L', mktime(0, 0, 0, 2, 1, $year)) === '1')
}
