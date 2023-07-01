:- object(partial_functions).

    :- public(show/0).

    show :-
        % create the partial functions
        create_partial_function(f1, PF1),
        create_partial_function(f2, PF2),
        % apply the partial functions
        Sequence1 = [0,1,2,3],
        call(PF1, Sequence1, PF1Sequence1), output_results(PF1, Sequence1, PF1Sequence1),
        call(PF2, Sequence1, PF2Sequence1), output_results(PF2, Sequence1, PF2Sequence1),
        Sequence2 = [2,4,6,8],
        call(PF1, Sequence2, PF1Sequence2), output_results(PF1, Sequence2, PF1Sequence2),
        call(PF2, Sequence2, PF2Sequence2), output_results(PF2, Sequence2, PF2Sequence2).

    create_partial_function(Closure, fs(Closure)).

    output_results(Function, Input, Output) :-
        write(Input), write(' -> '), write(Function), write(' -> '), write(Output), nl.

    fs(Closure, Arg1, Arg2) :-
        meta::map(Closure, Arg1, Arg2).

    f1(Value, Double) :-
        Double is 2*Value.

    f2(Value, Square) :-
        Square is Value*Value.

:- end_object.
