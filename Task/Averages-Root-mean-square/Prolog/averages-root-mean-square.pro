:- initialization(main).

rms(Xs, Y) :-
    sum_of_squares(Xs, 0, Sum),
    length(Xs, N),
    Y is sqrt(Sum / N).

sum_of_squares([], Sum, Sum).

sum_of_squares([X|Xs], A, Sum) :-
    A1 is A + X * X,
    sum_of_squares(Xs, A1, Sum).

main :-
    bagof(X, between(1, 10, X), Xs),
    rms(Xs, Y),
    format('The root-mean-square of 1..10 is ~f\n', [Y]).
