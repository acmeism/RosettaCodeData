<?php

function collapseString($string) {
    $previousChar = null;
    $collapse = '';
    $charArray = preg_split('//u', $string, -1, PREG_SPLIT_NO_EMPTY);
    for ($i = 0 ; $i < count($charArray) ; $i++) {
        $currentChar = $charArray[$i];
        if ($previousChar !== $currentChar) {
            $collapse .= $charArray[$i];
        }
        $previousChar = $currentChar;
    }
    return $collapse;
}

function isCollapsible($string) {
    return ($string !== collapseString($string));
}

$strings = array(
    '',
    'another non colapsing string',
    '"If I were two-faced, would I be wearing this one?" --- Abraham Lincoln ',
    '..1111111111111111111111111111111111111111111111111111111111111117777888',
    "I never give 'em hell, I just tell the truth, and they think it's hell. ",
    '                                                    --- Harry S Truman  ',
    '0112223333444445555556666666777777778888888889999999999',
    "The better the 4-wheel drive, the further you'll be from help when ya get stuck!",
    'headmistressship',
    "😍😀🙌💃😍😍😍🙌",
);

foreach ($strings as $original) {
    echo 'Original : <<<', $original, '>>> (len=', mb_strlen($original), ')', PHP_EOL;
    if (isCollapsible($original)) {
        $collapse = collapseString($original);
        echo 'Collapse : <<<', $collapse, '>>> (len=', mb_strlen($collapse), ')', PHP_EOL, PHP_EOL;
    } else {
        echo 'Collapse : string is not collapsing...', PHP_EOL, PHP_EOL;
    }
}
