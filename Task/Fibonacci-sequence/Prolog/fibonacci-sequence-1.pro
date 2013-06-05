fib(1, 1) :- !.
fib(0, 0) :- !.
fib(N, Value) :-
  A is N - 1, fib(A, A1),
  B is N - 2, fib(B, B1),
  Value is A1 + B1.
