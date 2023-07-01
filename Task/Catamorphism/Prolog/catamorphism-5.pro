:- use_module(library(clpfd)). % We are using #= instead of the raw "is".

foldy_len(_Item,ThreadIn,ThreadOut) :-
   succ(ThreadIn,ThreadOut).

foldy_add(Item,ThreadIn,ThreadOut) :-
   ThreadOut #= Item+ThreadIn.

foldy_mult(Item,ThreadIn,ThreadOut) :-
   ThreadOut #= Item*ThreadIn.

foldy_squadd(Item,ThreadIn,ThreadOut) :-
   ThreadOut #= Item+(ThreadIn^2).

% '[|]' is SWI-Prolog specific, replace by '.' as consbox constructor in other Prologs

foldy_build(Item,ThreadIn,ThreadOut) :-
   ThreadOut = '[|]'(Item,ThreadIn).

foldy_join(Item,ThreadIn,ThreadOut) :-
   (ThreadIn \= "")
   -> with_output_to(string(ThreadOut),format("~w,~w",[Item,ThreadIn]))
   ;  with_output_to(string(ThreadOut),format("~w",[Item])).

% '=..' ("univ") constructs a term from a list of functor and arguments

foldy_expr(Functor,Item,ThreadIn,ThreadOut) :-
   ThreadOut =.. [Functor,Item,ThreadIn].
