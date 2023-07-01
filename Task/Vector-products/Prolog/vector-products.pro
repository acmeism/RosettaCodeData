dot_product([A1, A2, A3], [B1, B2, B3], Ans) :-
    Ans is A1 * B1 + A2 * B2 + A3 * B3.

cross_product([A1, A2, A3], [B1, B2, B3], Ans) :-
    T1 is A2 * B3 - A3 * B2,
    T2 is A3 * B1 - A1 * B3,
    T3 is A1 * B2 - A2 * B1,
    Ans = [T1, T2, T3].

scala_triple(A, B, C, Ans) :-
    cross_product(B, C, Temp),
    dot_product(A, Temp, Ans).

vector_triple(A, B, C, Ans) :-
    cross_product(B, C, Temp),
    cross_product(A, Temp, Ans).
