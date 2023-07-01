fizzbuzz :-
   forall(between(1, 100, X), print_item(X)).

print_item(X) :-
   (  X mod 15 =:= 0
   -> write('FizzBuzz')
   ;  X mod 3 =:= 0
   -> write('Fizz')
   ;  X mod 5 =:= 0
   -> write('Buzz')
   ;  write(X)
   ),
   nl.
