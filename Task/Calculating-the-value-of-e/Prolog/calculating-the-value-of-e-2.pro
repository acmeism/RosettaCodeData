% John Devou: 26-Nov-2021
% Simple program to calculate e up to n decimal digits.
% Works fast for n ≤ 1 000 000.

l(M,F,L,S):- F > L -> S is M-1; M_ is M+1, F_ is F*M_, l(M_,F_,L,S).

e(S,X,Y,N,E):- S < 2 -> E is div(X*10**N,Y);
    S_ is S-1, X_ is X+Y, Y_ is S*Y, e(S_,X_,Y_,N,E).

main:-
    get_time(Start),				% start computation
    current_prolog_flag(argv,[X|_]),		% read arguments
    atom_number(X,N),				% convert first argument to number
    L is 3*10**(N+1), l(1,1,L,S),		% find the smallest S, such that (S+1)! > 3*10^(N+1)
    e(S,0,1,N,E),				% compute decimal part of series 1/2! + 1/3! + ... + 1/S!
    get_time(End),				% finish computation
    format("e = 2.~d\n",E),			% show number
    format("Computed in ~f sec",End- Start),	% show computation time
    halt.

?- main.
