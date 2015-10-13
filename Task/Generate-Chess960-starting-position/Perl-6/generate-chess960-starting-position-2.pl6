sub chess960 {
    .subst(:nth(2), /'♜'/, '♚') given
    first rx/ '♝' [..]* '♝' /,
    < ♛ ♜ ♜ ♜ ♝ ♝ ♞ ♞ >.pick(*).join xx *;
}

say chess960;
