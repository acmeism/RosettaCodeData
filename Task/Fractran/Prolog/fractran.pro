load(Program, Fractions) :-
    re_split("[ ]+", Program, Split), odd_items(Split, TextualFractions),
    maplist(convert_frac, TextualFractions, Fractions).

odd_items(L, L) :- L = [_], !.  % remove the even elements from a list.
odd_items([X,_|L], [X|R]) :- odd_items(L, R).

convert_frac(Text, Frac) :-
    re_matchsub("([0-9]+)/([0-9]+)"/t, Text, Match, []),
    Frac is Match.1 rdiv Match.2.

step(_, [], stop) :- !.
step(N, [F|Fs], R) :-
    A is N*F,
    (integer(A) -> R = A; step(N, Fs, R)).

exec(Prg, Start, Lz) :-
    lazy_list(transition, Prg/Start, Lz).

transition(Prg/N0, Prg/N1, N1) :-
    step(N0, Prg, N1).

steps(K, Start, Prg, Seq) :-
    exec(Prg, Start, Values),
    length(Seq, K), Seq = [Start|Rest], prefix(Rest, Values), !.


% The actual PRIMEGEN program follows...

primegen(Prg) :-
    load("17/91 78/85 19/51 23/38 29/33 77/29 95/23 77/19 1/17 11/13 13/11 15/14 15/2 55/1", Prg).

primes(N, Primes) :-
    primegen(Prg), exec(Prg, 2, Steps),
    length(Primes, N), capture_primes(Primes, Steps).

capture_primes([], _) :- !.
capture_primes([P|Ps], [Q|Qs]) :- pow2(Q), !, P is lsb(Q), capture_primes(Ps, Qs).
capture_primes(Ps, [_|Qs]) :- capture_primes(Ps, Qs).

pow2(X) :- X /\ (X-1) =:= 0.

main :-
    primegen(Prg), steps(15, 2, Prg, Steps),
    format("The first 15 steps from PRIMEGEN are: ~w~n", [Steps]),
    primes(20, Primes),
    format("By running PRIMEGEN we found these primes: ~w~n", [Primes]),
    halt.

?- main.
