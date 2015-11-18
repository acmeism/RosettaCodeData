| n |
userQuery report: 'Try to guess my secret number between 1 and 10.'.
n: random integerBetween: 1 And: 10.
[(userQuery askString: 'Guess the Number.') asInteger = n] whileFalse: [
    userQuery report: 'Nope. Guess again.'].
userQuery report: 'You got it!'
