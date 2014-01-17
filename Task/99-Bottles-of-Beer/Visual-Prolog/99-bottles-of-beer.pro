implement main
    open core, std, console

class predicates
    bottles : (integer) -> string procedure (i).

clauses
    bottles(1) = "bottle" :- !.
    bottles(_) = "bottles".

    run():-
        init(),
        foreach B = downTo(99,1) do
            write(B," ",bottles(B), " of beer on the wall,\n"),
            write(B," ",bottles(B), " of beer,\n"),
            write("Take one down, pass it around,\n"),
            write(B-1," ",bottles(B-1)," of beer on the wall.\n\n")
        end foreach,

        succeed().
end implement main

goal
    mainExe::run(main::run).
