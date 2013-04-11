prime(2).
prime(N) :- integer(N), N > 1,
    M is floor(sqrt(N+1)),    % round-off paranoia
    N mod 2 > 0,              % is odd
    check_by_odds(N, M, 3).

check_by_odds(N, M, S) :-
    M2 is (M-1) // 2, S2 is S // 2,
    forall( between(S2,M2,X), N mod (2*X+1) > 0 ).

/*
check_by_odds(N, M, F) :- F > M.
check_by_odds(N, M, F) :- F =< M,
    N mod F > 0,
    F1 is F + 2,              % test by odds only
    check_by_odds(N, M, F1).*/
