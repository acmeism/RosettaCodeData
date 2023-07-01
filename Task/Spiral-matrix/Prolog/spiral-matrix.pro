%  Prolog implementation: SWI-Prolog 7.2.3

replace([_|T], 0, E, [E|T]) :- !.
replace([H|T], N, E, Xs)    :-
  succ(N1, N), replace(T, N1, E, Xs1), Xs = [H|Xs1].

% True if Xs is the Original grid with the element at (X, Y) replaces by E.
replace_in([H|T], (0, Y), E, Xs) :- replace(H, Y, E, NH), Xs = [NH|T], !.
replace_in([H|T], (X, Y), E, Xs) :-
  succ(X1, X), replace_in(T, (X1, Y), E, Xs1), Xs = [H|Xs1].

% True, if E is the value at (X, Y) in Xs
get_in(Xs, (X, Y), E) :- nth0(X, Xs, L), nth0(Y, L, E).

create(N, Mx) :-             % NxN grid full of nils
  numlist(1, N, Ns),
  findall(X, (member(_, Ns), X = nil), Ls),
  findall(X, (member(_, Ns), X = Ls), Mx).

% Depending of the direction, returns two possible coordinates and directions
% (C,D) that will be used in case of a turn, and (A,B) otherwise.
ops(right, (X,Y), (A,B), (C,D), D1, D2) :-
  A is X, B is Y+1, D1 = right, C is X+1, D is Y, D2 = down.

ops(left, (X,Y), (A,B), (C,D), D1, D2) :-
  A is X, B is Y-1, D1 = left, C is X-1, D is Y, D2 = up.

ops(up, (X,Y), (A,B), (C,D), D1, D2) :-
  A is X-1, B is Y, D1 = up, C is X, D is Y+1, D2 = right.

ops(down, (X,Y), (A,B), (C,D), D1, D2) :-
  A is X+1, B is Y, D1 = down, C is X, D is Y-1, D2 = left.

% True if NCoor is the right coor in spiral shape. Returns a new direction also.
next(Dir, Mx, Coor, NCoor, NDir) :-
  ops(Dir, Coor, C1, C2, D1, D2),
  (get_in(Mx, C1, nil) -> NCoor = C1, NDir = D1
                        ; NCoor = C2, NDir = D2).

% Returns an spiral with [H|Vs] elements called R, only work if the length of
% [H|Vs], is the square of the size of the grid.
spiralH(Dir, Mx, Coor, [H|Vs], R)  :-
 replace_in(Mx, Coor, H, NMx),
 (Vs = [] -> R = NMx
           ; next(Dir, Mx, Coor, NCoor, NDir),
             spiralH(NDir, NMx, NCoor, Vs, R)).

% True if Mx is the grid in spiral shape of the numbers from 0 to N*N-1.
spiral(N, Mx) :-
  Sq is N*N-1, numlist(0, Sq, Ns),
  create(N, EMx), spiralH(right, EMx, (0,0), Ns, Mx).
