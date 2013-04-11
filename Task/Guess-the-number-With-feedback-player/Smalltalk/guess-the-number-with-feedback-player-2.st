playBetween: low and: high
    Transcript clear.
    number := (low to: high) atRandom.
    self playBetween: low and: high atTurn: 1.

playBetween: low and: high atTurn: turn
    | guess |
    guess := (low + ((high - low) / 2)) asInteger.
    self showGuessing: guess atTurn: turn.
    true caseOf: {
        [number > guess] ->
            [self showNumberBeing: #low. self playBetween: guess and: high atTurn: turn+1 ].
        [number < guess] ->
            [self showNumberBeing: #high. self playBetween: low and: guess atTurn: turn+1 ].
        [true] ->
            [self showNumberFoundAtTurnNr: turn ] }.

showGuessing: guess atTurn: turn
    Transcript show: ('{1}. guessing: {2}' format: {turn asString. guess asString}).

showNumberBeing: comparisonToken
    Transcript show: ' ==> too ', (comparisonToken asString); cr.

showNumberFoundAtTurnNr: turn
    Transcript show: (' ==> found the number in {1} turn(s).' format: {turn asString}); cr.
