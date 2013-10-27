:- object(trignomeric_functions).

    :- public(show/0).
    show :-
        % standard trignomeric functions work with radians
        write('sin(pi/4.0) = '), SIN is sin(pi/4.0), write(SIN), nl,
        write('cos(pi/4.0) = '), COS is cos(pi/4.0), write(COS), nl,
        write('tan(pi/4.0) = '), TAN is tan(pi/4.0), write(TAN), nl,
        write('asin(sin(pi/4.0)) = '), ASIN is asin(sin(pi/4.0)), write(ASIN), nl,
        write('acos(cos(pi/4.0)) = '), ACOS is acos(cos(pi/4.0)), write(ACOS), nl,
        write('atan(tan(pi/4.0)) = '), ATAN is atan(tan(pi/4.0)), write(ATAN), nl,
        write('atan2(3,4) = '), ATAN2 is atan2(3,4), write(ATAN2), nl.

:- end_object.
