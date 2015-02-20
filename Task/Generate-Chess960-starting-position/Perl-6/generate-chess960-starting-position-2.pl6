constant chess960 =
    map *.subst(:nth(2), /'♜'/, '♚'),
        grep rx/ '♝' [..]* '♝' /,
             < ♛ ♜ ♜ ♜ ♝ ♝ ♞ ♞ >.pick(*).join xx *;

.say for chess960[^10];
