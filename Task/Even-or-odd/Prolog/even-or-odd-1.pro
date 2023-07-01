  even(N) :-
     (between(0, inf, N); integer(N) ),
     0 is N mod 2.
