implement main
    open core, std

domains
    pythtrip = pt(integer, integer, integer).

class predicates
    pythTrips : (integer) -> pythtrip nondeterm (i).

clauses
    pythTrips(Limit) = pt(X,Y,Z) :-
        X = fromTo(1,Limit),
        Y = fromTo(X,Limit),
        Z = fromTo(Y,Limit),
        Z^2 = X^2 + Y^2.

    run():-
        console::init(),
        Triples = [ X || X = pythTrips(20) ],
        console::write(Triples),
        Junk = console::readLine(),
        succeed().
end implement main

goal
    mainExe::run(main::run).
