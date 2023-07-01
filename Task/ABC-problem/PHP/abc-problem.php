<?php
$words = array("A", "BARK", "BOOK", "TREAT", "COMMON", "SQUAD", "Confuse");

function canMakeWord($word) {
    $word = strtoupper($word);
    $blocks = array(
            "BO", "XK", "DQ", "CP", "NA",
            "GT", "RE", "TG", "QD", "FS",
            "JW", "HU", "VI", "AN", "OB",
            "ER", "FS", "LY", "PC", "ZM",
    );

    foreach (str_split($word) as $char) {
        foreach ($blocks as $k => $block) {
            if (strpos($block, $char) !== FALSE) {
                unset($blocks[$k]);
                continue(2);
            }
        }
        return false;
    }
    return true;
}

foreach ($words as $word) {
    echo $word.': ';
    echo canMakeWord($word) ? "True" : "False";
    echo "\r\n";
}
