iterate(Phi0, N0, Phi, N) :-
    Phi1 = (1.0 + (1.0 / Phi0)),
    N1 is N0 + 1,
    ((abs(Phi1 - Phi0) =< 1.0e-5)
    -> (Phi = Phi1, N = N1)
    ;  iterate(Phi1, N1, Phi, N)).

main :-
    iterate(1.0, 0, Phi, N),
    PhiApprox is Phi,
    Error is Phi - (0.5 * (1.0 + sqrt(5.0))),
    write('Final Phi = '),
    write(Phi),
    write('\n  which is approximately '),
    write(PhiApprox),
    write('\n'),
    write(N),
    write(' iterations were required.'),
    write('\nThe error is approximately '),
    write(Error),
    write('\n'),
    halt.

:- initialization(main).
