<?php

function squeezeString($string, $squeezeChar) {
    $previousChar = null;
    $squeeze = '';
    $charArray = preg_split('//u', $string, -1, PREG_SPLIT_NO_EMPTY);
    for ($i = 0 ; $i < count($charArray) ; $i++) {
        $currentChar = $charArray[$i];
        if ($previousChar !== $currentChar || $currentChar !== $squeezeChar) {
            $squeeze .= $charArray[$i];
        }
        $previousChar = $currentChar;
    }
    return $squeeze;
}

function isSqueezable($string, $squeezeChar) {
    return ($string !== squeezeString($string, $squeezeChar));
}

$strings = array(
    ['-', '"If I were two-faced, would I be wearing this one?" --- Abraham Lincoln '],
    ['1', '..1111111111111111111111111111111111111111111111111111111111111117777888'],
    ['l', "I never give 'em hell, I just tell the truth, and they think it's hell. "],
    [' ', '                                                    --- Harry S Truman  '],
    ['9', '0112223333444445555556666666777777778888888889999999999'],
    ['e', "The better the 4-wheel drive, the further you'll be from help when ya get stuck!"],
    ['k', "The better the 4-wheel drive, the further you'll be from help when ya get stuck!"],
);
foreach ($strings as $params) {
    list($char, $original) = $params;
    echo 'Original   : <<<', $original, '>>> (len=', mb_strlen($original), ')', PHP_EOL;
    if (isSqueezable($original, $char)) {
        $squeeze = squeezeString($original, $char);
        echo 'Squeeze(', $char, ') : <<<', $squeeze, '>>> (len=', mb_strlen($squeeze), ')', PHP_EOL, PHP_EOL;
    } else {
        echo 'Squeeze(', $char, ') : string is not squeezable (char=', $char, ')...', PHP_EOL, PHP_EOL;
    }
}
