fizzbuzz :-
        foreach(between(1, 100, X), print_item(X)).

print_item(X) :-
        (  0 is X mod 15
        -> print('FizzBuzz')
        ;  0 is X mod 3
        -> print('Fizz')
        ;  0 is X mod 5
        -> print('Buzz')
        ;  print(X)
        ),
        nl.
