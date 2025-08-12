:- use_module(library(dcg/basics)).
:- use_module(library(dcg/high_order)).

main :-
    % ask for 11 numbers to be read into a sequence S
    format("Enter 11 numbers for evaluation~n", []),
    length(S, 11),
    phrase_from_stream((sequence(integer, "\n", S), remainder(_)), user_input),

    % reverse sequence S
    reverse(S, ReversedS),

    % for each item in sequence S
    foreach((
        member(Item, ReversedS),
        % result := call a function to do an operation
        Result is sqrt(abs(Item)) + 5 * Item ^ 3
    ),
        % if result overflows
        (   Result > 400
        %   alert user
        ->  format("~d: OVERFLOW~n", [Item])
        %   else print result
        ;   format("~d: ~f~n", [Item, Result])
        )
    ).
