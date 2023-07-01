ft_rows(Lz) :-
    lazy_list(ft_row, [], Lz).

ft_row([], R1, R1) :- R1 = [1].
ft_row(R0, R2, R2) :-
    length(R0, P),
    Jmax is 1 + P, numlist(2, Jmax, Qs),
    maplist(term(P), Qs, R0, R1),
    sum_list(R1, S), Bk is 1 - S, % Bk is Bernoulli number
    R2 = [Bk | R1].

term(P, Q, R, S) :- S is R * (P rdiv Q).

show(N) :-
    ft_rows(Rs),
    length(Rows, N), prefix(Rows, Rs),
    forall(
        member(R, Rows),
            (format(string(S), "~w", [R]),
             re_replace(" rdiv "/g, "/", S, T),
             re_replace(","/g, ", ", T, U),
             write(U), nl)).

sum(N, K, S) :- % sum I=1,N (I ** K)
    ft_rows(Rows), drop(K, Rows, [Coefs|_]),
    reverse([0|Coefs], Poly),
    foldl(horner(N), Poly, 0, S).

horner(N, A, S0, S1) :-
    S1 is N*S0 + A.

drop(N, Lz1, Lz2) :-
    append(Pfx, Lz2, Lz1), length(Pfx, N), !.
