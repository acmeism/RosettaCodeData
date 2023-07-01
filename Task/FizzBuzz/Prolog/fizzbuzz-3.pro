%        N  /3?  /5?  V
fizzbuzz(_, yes, yes, 'FizzBuzz').
fizzbuzz(_, yes, no,  'Fizz').
fizzbuzz(_, no,  yes, 'Buzz').
fizzbuzz(N, no,  no,  N).

% Unifies V with 'yes' if D divides evenly into N, 'no' otherwise.
divisible_by(N, D, yes) :- N mod D =:= 0.
divisible_by(N, D, no) :- N mod D =\= 0.

% Print 'Fizz', 'Buzz', 'FizzBuzz' or N as appropriate.
fizz_buzz_or_n(N) :- N > 100.
fizz_buzz_or_n(N) :- N =< 100,
   divisible_by(N, 3, Fizz),
   divisible_by(N, 5, Buzz),
   fizzbuzz(N, Fizz, Buzz, FB),
   write(FB), nl,
   M is N+1, fizz_buzz_or_n(M).

main :-
   fizz_buzz_or_n(1).
