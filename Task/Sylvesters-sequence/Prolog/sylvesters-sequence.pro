sylvesters_sequence(N, S, R):-
    sylvesters_sequence(N, S, 2, R, 0).

sylvesters_sequence(0, [X], X, R, S):-
    !,
    R is S + 1 rdiv X.
sylvesters_sequence(N, [X|Xs], X, R, S):-
    Y is X * X - X + 1,
    M is N - 1,
    T is S + 1 rdiv X,
    sylvesters_sequence(M, Xs, Y, R, T).

main:-
    sylvesters_sequence(9, Sequence, Sum),
    writeln('First 10 elements in Sylvester\'s sequence:'),
    forall(member(S, Sequence), writef('%t\n', [S])),
    N is numerator(Sum),
    D is denominator(Sum),
    writef('\nSum of reciprocals: %t / %t\n', [N, D]).
