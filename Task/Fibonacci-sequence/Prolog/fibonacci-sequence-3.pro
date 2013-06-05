%:- dynamic fib/2.  % This is ISO, but GNU doesn't like it.
:- dynamic(fib/2).  % Not ISO, but works in SWI, YAP and GNU unlike the ISO declaration.
fib(1, 1) :- !.
fib(0, 0) :- !.
fib(N, Value) :-
  A is N - 1, fib(A, A1),
  B is N - 2, fib(B, B1),
  Value is A1 + B1,
  asserta((fib(N, Value) :- !)).
