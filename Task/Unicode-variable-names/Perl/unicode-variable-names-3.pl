use utf8;
use v5.10;

sub Δ () : lvalue {
    state $val;
}

Δ = 1;
Δ++;
say Δ;
