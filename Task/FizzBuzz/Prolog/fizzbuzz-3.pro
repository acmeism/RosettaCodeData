%        N  /3?  /5?  V
fizzbuzz(_, yes, yes, 'FizzBuzz').
fizzbuzz(_, yes, no,  'Fizz').
fizzbuzz(_, no,  yes, 'Buzz').
fizzbuzz(N, no,  no,  N).

% Unifies V with 'yes' if D divides evenly into N, 'no' otherwise.
divisible_by(N, D, V) :-
  ( 0 is N mod D -> V = yes
  ;                 V = no).

% Print 'Fizz', 'Buzz', 'FizzBuzz' or N as appropriate.
fizz_buzz_or_n(N) :-
  divisible_by(N, 3, Fizz),
  divisible_by(N, 5, Buzz),
  fizzbuzz(N, Fizz, Buzz, FB),
  format("~p -> ~p~n", [N, FB]).

main :-
  foreach(between(1,100, N), fizz_buzz_or_n(N)).
