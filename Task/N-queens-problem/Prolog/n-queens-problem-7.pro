% John Devou: 26-Nov-2021
% Short solution to use on https://swish.swi-prolog.org/.
% Works fast for n ≤ 17.

:- use_rendering(chess).

q(_,0,[],[]).
q(N,R,[(R,C)|Qs],[C|Cs]):- R > 0, S is R-1, q(N,S,Qs,Cs), between(1,N,C),
	not((member((U,V),Qs), (V =:= C; R-U =:= abs(C-V)))).
q(N,X):- q(N,N,_,X).
