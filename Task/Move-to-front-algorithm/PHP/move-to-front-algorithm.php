<?php

function symbolTable() {
    $symbol = array();
    for ($c = ord('a') ; $c <= ord('z') ; $c++) {
        $symbol[$c - ord('a')] = chr($c);
    }
    return $symbol;
}

function mtfEncode($original, $symbol) {
    $encoded = array();
    for ($i = 0 ; $i < strlen($original) ; $i++) {
        $char = $original[$i];
        $position = array_search($char, $symbol);
        $encoded[] = $position;
        $mtf = $symbol[$position];
        unset($symbol[$position]);
        array_unshift($symbol, $mtf);
    }
    return $encoded;
}

function mtfDecode($encoded, $symbol) {
    $decoded = '';
    foreach ($encoded AS $position) {
        $char = $symbol[$position];
        $decoded .= $char;
        unset($symbol[$position]);
        array_unshift($symbol, $char);
    }
    return $decoded;
}

foreach (array('broood', 'bananaaa', 'hiphophiphop') AS $original) {
    $encoded = mtfEncode($original, symbolTable());
    $decoded = mtfDecode($encoded, symbolTable());
    echo
        $original,
        ' -> [', implode(',', $encoded), ']',
        ' -> ', $decoded,
        ' : ', ($original === $decoded ? 'OK' : 'Error'),
        PHP_EOL;
}
