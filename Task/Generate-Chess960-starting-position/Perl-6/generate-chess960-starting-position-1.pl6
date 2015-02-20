repeat until m/ '♗' [..]* '♗' / { $_ = < ♖ ♖ ♖ ♕ ♗ ♗ ♘ ♘ >.pick(*).join }
s:2nd['♖'] = '♔';
say .comb;
