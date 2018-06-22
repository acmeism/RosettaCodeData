constant chess960 =
   < ♛ ♜ ♜ ♜ ♝ ♝ ♞ ♞ >.permutations».join.unique.grep( / '♝' [..]* '♝' / )».subst(:nth(2), /'♜'/, '♚');

.say for chess960;
