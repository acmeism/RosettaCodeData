<?php

// Automated text generator using markov chain
function markovChainTextGenerator($text, $keySize, $maxWords) {

    // Create list of tokens
    $token = array();
    $position = 0;
    $maxPosition = strlen($text);
    while ($position < $maxPosition) {
        if (preg_match('/^(\S+)/', substr($text, $position, 25), $matches)) {
            $token[] = $matches[1];
            $position += strlen($matches[1]);
        }
        elseif (preg_match('/^(\s+)/', substr($text, $position, 25), $matches)) {
            $position += strlen($matches[1]);
        }
        else {
            die(
                'Unknown token found at position ' . $position . ' : ' .
                substr($text, $position, 25) . '...' . PHP_EOL
            );
        }
    }

    // Create Dictionary
    $dictionary = array();
    for ($i = 0 ; $i < count($token) - $keySize ; $i++) {
        $prefix = '';
        $separator = '';
        for ($c = 0 ; $c < $keySize ; $c++) {
            $prefix .= $separator . $token[$i + $c];
            $separator = '.';
        }
        $dictionary[$prefix][] = $token[$i + $keySize];
    }

    // Starting token
    $rand = rand(0, count($token) - $keySize);
    $startToken = array();
    for ($c = 0 ; $c < $keySize ; $c++) {
        array_push($startToken, $token[$rand + $c]);
    }

    // Create Text
    $text = implode(' ', $startToken);
    $words = $keySize;
    do {
        $tokenKey = implode('.', $startToken);
        $rand = rand(0, count($dictionary[$tokenKey]) - 1);
        $newToken = $dictionary[$tokenKey][$rand];
        $text .= ' ' . $newToken;
        $words++;
        array_shift($startToken);
        array_push($startToken, $newToken);
    } while($words < $maxWords);
    return $text;

}

srand(5678);

$text = markovChainTextGenerator(
    file_get_contents(__DIR__ . '/inc/alice_oz.txt'),
    3,
    308
);

echo wordwrap($text, 100, PHP_EOL) . PHP_EOL;
