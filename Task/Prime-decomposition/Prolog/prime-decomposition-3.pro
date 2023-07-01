factors( N, FS):-
    factors2( N, FS).

factors2( N, FS):-
    ( N < 2        -> FS = []
    ; 4 > N        -> FS = [N]
    ; 0 is N rem 2 -> FS = [K|FS2], N2 is N div 2, factors2( N2, FS2)
    ;                 factors( N, 3, FS)
    ).

factors( N, K, FS):-
    ( N < 2        -> FS = []
    ; K*K > N      -> FS = [N]
    ; 0 is N rem K -> FS = [K|FS2], N2 is N div K, factors( N2, K, FS2)
    ;                 K2 is K+2, factors( N, K2, FS)
    ).
