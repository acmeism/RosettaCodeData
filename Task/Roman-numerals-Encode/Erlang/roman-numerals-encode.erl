-module(roman).
-export([to_roman/1]).

to_roman(0) -> [];
to_roman(X) when X >= 1000 -> [$M | to_roman(X - 1000)];
to_roman(X) when X >= 100 ->
    digit(X div 100, $C, $D, $M) ++ to_roman(X rem 100);
to_roman(X) when X >= 10 ->
    digit(X div 10, $X, $L, $C) ++ to_roman(X rem 10);
to_roman(X) when X >= 1 -> digit(X, $I, $V, $X).

digit(1, X, _, _) -> [X];
digit(2, X, _, _) -> [X, X];
digit(3, X, _, _) -> [X, X, X];
digit(4, X, Y, _) -> [X, Y];
digit(5, _, Y, _) -> [Y];
digit(6, X, Y, _) -> [Y, X];
digit(7, X, Y, _) -> [Y, X, X];
digit(8, X, Y, _) -> [Y, X, X, X];
digit(9, X, _, Z) -> [X, Z].
