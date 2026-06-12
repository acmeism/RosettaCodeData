digit_sum(N, M) :- digit_sum(N, 0, M).
digit_sum(0, A, B) :- !, A = B.
digit_sum(N, A0, M) :-
    divmod(N, 10, Q, R),
    plus(A0, R, A1),
    digit_sum(Q, A1, M).

prime_digits(0).
prime_digits(N) :-
    prime_digits(M),
    member(D, [2, 3, 5, 7]),
    N is 10 * M + D.	

prime13(N) :-
    prime_digits(N),
    (N > 333_333 -> !, false ; true),
    digit_sum(N, 13).

main :-
    findall(N, prime13(N), S),
    format("Those numbers whose digits are all prime and sum to 13 are: ~n~w~n", [S]),
    halt.

?- main.
