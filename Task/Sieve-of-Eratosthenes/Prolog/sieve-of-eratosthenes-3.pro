sieve(N, [2|PS]) :-       % PS is list of odd primes up to N
    retractall(mult(_)),
    sieve_O(3,N,PS).

sieve_O(I,N,PS) :-        % sieve odds from I up to N to get PS
    I =< N, !, I1 is I+2,
    (   mult(I) -> sieve_O(I1,N,PS)
    ;   (   I =< N / I ->
            ISq is I*I, DI  is 2*I, add_mults(DI,ISq,N)
        ;   true
        ),
        PS = [I|T],
        sieve_O(I1,N,T)
    ).
sieve_O(I,N,[]) :- I > N.

add_mults(DI,I,N) :-
    I =< N, !,
    ( mult(I) -> true ; assert(mult(I)) ),
    I1 is I+DI,
    add_mults(DI,I1,N).
add_mults(_,I,N) :- I > N.

main(N) :- current_prolog_flag(verbose,F),
  set_prolog_flag(verbose,normal),
  time( sieve( N,P)), length(P,Len), last(P, LP), writeln([Len,LP]),
  set_prolog_flag(verbose,F).

:- dynamic( mult/1 ).
:- main(100000), main(1000000).
