constant chess960 = eager
    .subst(:nth(2), /'♜'/, '♚')
        if / '♝' [..]* '♝' /
            for < ♛ ♜ ♜ ♜ ♝ ♝ ♞ ♞ >.permutations».join.uniq;

.say for chess960;
