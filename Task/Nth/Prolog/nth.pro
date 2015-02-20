nth(N, N_Th) :-
    ( tween(N)      -> Th = "th"
    ; 1 is N mod 10 -> Th = "st"
    ; 2 is N mod 10 -> Th = "nd"
    ; 3 is N mod 10 -> Th = "rd"
    ; Th = "th" ),
    string_concat(N, Th, N_Th).

tween(N) :- Tween is N mod 100, between(11, 13, Tween).

test :-
    forall( between(0,25, N),     (nth(N, N_Th), format('~w, ', N_Th)) ),
    nl, nl,
    forall( between(250,265,N),   (nth(N, N_Th), format('~w, ', N_Th)) ),
    nl, nl,
    forall( between(1000,1025,N), (nth(N, N_Th), format('~w, ', N_Th)) ).
