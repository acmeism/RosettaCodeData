?- use_module(library(heaps)).

prime(2).
prime(N) :- prime_heap(N, _).

prime_heap(3, H) :- list_to_heap([9-6], H).
prime_heap(N, H) :-
    prime_heap(M, H0), N0 is M + 2,
    next_prime(N0, H0, N, H).

next_prime(N0, H0, N, H) :-
    \+ min_of_heap(H0, N0, _),
    N = N0, Composite is N*N, Skip is N+N,
    add_to_heap(H0, Composite, Skip, H).
next_prime(N0, H0, N, H) :-
    min_of_heap(H0, N0, _),
    adjust_heap(H0, N0, H1), N1 is N0 + 2,
    next_prime(N1, H1, N, H).

adjust_heap(H0, N, H) :-
    min_of_heap(H0, N, _),
    get_from_heap(H0, N, Skip, H1),
    Composite is N + Skip, add_to_heap(H1, Composite, Skip, H2),
    adjust_heap(H2, N, H).
adjust_heap(H, N, H) :-
    \+ min_of_heap(H, N, _).
