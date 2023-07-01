implement main
    open core

clauses
    run():-
        console::init(),
        stdio::write(a(10, {() = 1}, {() = -1}, {() = -1}, {() = 1}, {() = 0})).

class predicates
    a : (integer K, function{integer} X1, function{integer} X2, function{integer} X3, function{integer} X4, function{integer} X5) -> integer Result.
clauses
    a(K, X1, X2, X3, X4, X5) = R :-
        KM = varM::new(K),
        BM = varM{function{integer}}::new({() = 0}),
        BM:value :=
            { () = BR :-
                KM:value := KM:value-1,
                BR = a(KM:value, BM:value, X1, X2, X3, X4)
            },
        R = if KM:value <= 0 then X4() + X5() else BM:value() end if.

end implement main
