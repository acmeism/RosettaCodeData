playBetween: low and: high atTurn: turn
    | guess |
    guess := (low + ((high - low) / 2)) asInteger.
    self showGuessing: guess atTurn: turn.
    (guess = number)
        ifTrue: [self showNumberFoundAtTurnNr: turn ]
        ifFalse: [
          (number > guess)
              ifTrue: [self showNumberBeing: #low. self playBetween: guess and: high  atTurn: turn+1 ]
              ifFalse: [self showNumberBeing: #high. self playBetween: low and: guess  atTurn: turn+1]].
