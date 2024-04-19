tau(N, T) :-
    findall(M, (between(1, N, M), 0 is N mod M), Ms),
    length(Ms, T).

tau_numbers(Limit, Ns) :-
    findall(N, (between(1, Limit, N), tau(N, T), 0 is N mod T), Ns).

print_tau_numbers :-
    tau_numbers(1100, Ns),
    writeln("The first 100 tau numbers are:"),
    forall(member(N, Ns), format("~d ", [N])).

:- print_tau_numbers.
