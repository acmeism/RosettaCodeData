implement main
   open core, console

class predicates
   fizzbuzz : (integer) -> string procedure (i).

clauses
    fizzbuzz(X) = S :- X mod 15 = 0, S = "FizzBuzz", !.
    fizzbuzz(X) = S :- X mod 5 = 0, S = "Buzz", !.
    fizzbuzz(X) = S :- X mod 3 = 0, S = "Fizz", !.
    fizzbuzz(X) = S :- S = toString(X).

    run() :-
        foreach X = std::fromTo(1,100) do
            write(fizzbuzz(X)), write("\n")
        end foreach,
        succeed.

end implement main

goal
    console::runUtf8(main::run).
