%%%%% compatibility section %%%%%

:- if(current_prolog_flag(dialect, yap)).
generate(Min, I) :- between(Min, inf, I).

append([],L,L).
append([X|Xs], L, [X|Ls]) :- append(Xs,L,Ls).

:- endif.

:- if(current_prolog_flag(dialect, swi)).
generate(Min, I) :- between(Min, inf, I).
:- endif.

:- if(current_prolog_flag(dialect, yap)).
append([],L,L).
append([X|Xs], L, [X|Ls]) :- append(Xs,L,Ls).

last([X], X).
last([_|Xs],X) :- last(Xs,X).

:- endif.

:- if(current_prolog_flag(dialect, gprolog)).
generate(Min, I) :-
  current_prolog_flag(max_integer, Max),
  between(Min, Max, I).
:- endif.
