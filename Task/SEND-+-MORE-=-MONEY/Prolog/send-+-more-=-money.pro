leading_digit(1).
leading_digit(2).
leading_digit(3).
leading_digit(4).
leading_digit(5).
leading_digit(6).
leading_digit(7).
leading_digit(8).
leading_digit(9).

digit(0).
digit(X) :- leading_digit(X).

distinct([]).
distinct([X|Xs]) :- \+ member(X, Xs), distinct(Xs).

puzzle(SEND, MORE, MONEY) :-
   leading_digit(S), digit(E), digit(N), digit(D), leading_digit(M), digit(O), digit(R), digit(Y),
   distinct([S, E, N, D, M, O, R, Y]),
   SEND is 1000*S + 100*E + 10*N + D,
   MORE is 1000*M + 100*O + 10*R + E,
   MONEY is 10000*M + 1000*O + 100*N + 10*E + Y,
   MONEY is SEND + MORE.
