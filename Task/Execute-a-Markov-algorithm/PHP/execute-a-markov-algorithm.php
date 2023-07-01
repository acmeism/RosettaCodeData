<?php

function markov($text, $ruleset) {
    $lines = explode(PHP_EOL, $ruleset);
    $rules = array();
    foreach ($lines AS $line) {
        $spc = "[\t ]+";
        if (empty($line) OR preg_match('/^#/', $line)) {
            continue;
        } elseif (preg_match('/^(.+)' . $spc . '->' . $spc . '(\.?)(.*)$/', $line, $matches)) {
            list($dummy, $pattern, $terminating, $replacement) = $matches;
            $rules[] = array(
                'pattern'     => trim($pattern),
                'terminating' => ($terminating === '.'),
                'replacement' => trim($replacement),
            );
        }
    }
    do {
        $found = false;
        foreach ($rules AS $rule) {
            if (strpos($text, $rule['pattern']) !== FALSE) {
                $text = str_replace($rule['pattern'], $rule['replacement'], $text);
                if ($rule['terminating']) {
                    return $text;
                }
                $found = true;
                break;
            }
        }
    } while($found);
    return $text;
}

$conf = array(
    1 => array(
        'text' => 'I bought a B of As from T S.',
        'rule' => '
            # This rules file is extracted from Wikipedia:
            # http://en.wikipedia.org/wiki/Markov_Algorithm
            A -> apple
            B -> bag
            S -> shop
            T -> the
            the shop -> my brother
            a never used -> .terminating rule
        ',
    ),
    2 => array(
        'text' => 'I bought a B of As from T S.',
        'rule' => '
            # Slightly modified from the rules on Wikipedia
            A -> apple
            B -> bag
            S -> .shop
            T -> the
            the shop -> my brother
            a never used -> .terminating rule
        ',
    ),
    3 => array(
        'text' => 'I bought a B of As W my Bgage from T S.',
        'rule' => '
            # BNF Syntax testing rules
            A -> apple
            WWWW -> with
            Bgage -> ->.*
            B -> bag
            ->.* -> money
            W -> WW
            S -> .shop
            T -> the
            the shop -> my brother
            a never used -> .terminating rule
        ',
    ),
    4 => array(
        'text' => '_1111*11111_',
        'rule' => '
            ### Unary Multiplication Engine, for testing Markov Algorithm implementations
            ### By Donal Fellows.
            # Unary addition engine
            _+1 -> _1+
            1+1 -> 11+
            # Pass for converting from the splitting of multiplication into ordinary
            # addition
            1! -> !1
            ,! -> !+
            _! -> _
            # Unary multiplication by duplicating left side, right side times
            1*1 -> x,@y
            1x -> xX
            X, -> 1,1
            X1 -> 1X
            _x -> _X
            ,x -> ,X
            y1 -> 1y
            y_ -> _
            # Next phase of applying
            1@1 -> x,@y
            1@_ -> @_
            ,@_ -> !_
            ++ -> +
            # Termination cleanup for addition
            _1 -> 1
            1+_ -> 1
            _+_ ->
        ',
    ),
    5 => array(
        'text' => '000000A000000',
        'rule' => '
            # Turing machine: three-state busy beaver
            #
            # state A, symbol 0 => write 1, move right, new state B
            A0 -> 1B
            # state A, symbol 1 => write 1, move left, new state C
            0A1 -> C01
            1A1 -> C11
            # state B, symbol 0 => write 1, move left, new state A
            0B0 -> A01
            1B0 -> A11
            # state B, symbol 1 => write 1, move right, new state B
            B1 -> 1B
            # state C, symbol 0 => write 1, move left, new state B
            0C0 -> B01
            1C0 -> B11
            # state C, symbol 1 => write 1, move left, halt
            0C1 -> H01
            1C1 -> H11
        ',
    ),
    6 => array(
        'text' => '101',
        'rule' => '
            # Another example extracted from Wikipedia:
            # http://en.wikipedia.org/wiki/Markov_Algorithm
            1  -> 0|
            |0 -> 0||
            0  ->
        ',
    ),
);

foreach ($conf AS $id => $rule) {
    echo 'Ruleset ', $id, ' : ', markov($rule['text'], $rule['rule']), PHP_EOL;
}
