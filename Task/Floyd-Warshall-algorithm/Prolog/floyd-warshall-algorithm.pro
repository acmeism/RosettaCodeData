:- use_module(library(clpfd)).

path(List, To, From, [From], W) :-
    select([To,From,W],List,_).
path(List, To, From, [Link|R], W) :-
    select([To,Link,W1],List,Rest),
    W #= W1 + W2,
    path(Rest, Link, From, R, W2).

find_path(Din, From, To, [From|Pout], Wout) :-
    between(1, 4, From),
    between(1, 4, To),
    dif(From, To),
    findall([W,P], (
                path(Din, From, To, P, W),
                all_distinct(P)
            ), Paths),
    sort(Paths, [[Wout,Pout]|_]).


print_all_paths :-
    D = [[1, 3, -2], [2, 3, 3], [2, 1, 4], [3, 4, 2], [4, 2, -1]],
    format('Pair\t  Dist\tPath~n'),
    forall(
        find_path(D, From, To, Path, Weight),(
            atomic_list_concat(Path, ' -> ', PPath),
            format('~p -> ~p\t  ~p\t~w~n', [From, To, Weight, PPath]))).
