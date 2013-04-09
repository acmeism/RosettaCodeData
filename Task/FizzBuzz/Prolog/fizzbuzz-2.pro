fizzbuzz(X) :- 0 is X mod 15, write('FizzBuzz').
fizzbuzz(X) :- 0 is X mod 3, write('Fizz').
fizzbuzz(X) :- 0 is X mod 5, write('Buzz').
fizzbuzz(X) :- write(X).

dofizzbuzz :- foreach(between(1, 100, X), (fizzbuzz(X),nl)).
