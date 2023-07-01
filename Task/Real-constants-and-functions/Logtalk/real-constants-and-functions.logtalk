:- object(constants_and_functions).

    :- public(show/0).
    show :-
        write('e = '), E is e, write(E), nl,
        write('pi = '), PI is pi, write(PI), nl,
        write('sqrt(2) = '), SQRT is sqrt(2), write(SQRT), nl,
        % only base e logorithm is avaialable as a standard built-in function
        write('log(2) = '), LOG is log(2), write(LOG), nl,
        write('exp(2) = '), EXP is exp(2), write(EXP), nl,
        write('abs(-1) = '), ABS is abs(-1), write(ABS), nl,
        write('floor(-3.4) = '), FLOOR is floor(-3.4), write(FLOOR), nl,
        write('ceiling(-3.4) = '), CEILING is ceiling(-3.4), write(CEILING), nl,
        write('2 ** -3.4 = '), POWER is 2 ** -3.4, write(POWER), nl.

:- end_object.
