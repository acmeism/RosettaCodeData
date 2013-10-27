take( 0, Next, Z-Z, Next).
take( N, Next, [A|B]-Z, NZ):- N>0, !, next( Next, A, Next1),
  N1 is N-1,
  take( N1, Next1, B-Z, NZ).

next( fib(A,B), A, fib(B,C)):- C is A+B.

%% usage: ?- take(15, fib(0,1), _X-[], G), writeln(_X).
%% [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377]
%% G = fib(610, 987)
