:- use_module(library(function_expansion)).

user:function_expansion(multiply(A, B), P, P is A * B).  % "function" definition

go :-
  format("The product is ~d.~n", [multiply(5, 2)]).
