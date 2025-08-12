topswops(N, MaximumSwaps) :-
    numlist(1, N, Cards),
    aggregate_all(max(Swaps), (
        permutation(Cards, Shuffled),
        topswops_(Shuffled, 0, Swaps)
    ), MaximumSwaps).

topswops_([Card | Cards0], Swaps0, Swaps) :-
    (   Card = 1
    ->  Swaps0 = Swaps
    ;   succ(Swaps0, Swaps1),
        length(Prefix, Card),
        append(Prefix, Suffix, [Card | Cards0]),
        reverse(Prefix, Reversed),
        append(Reversed, Suffix, Cards),
        topswops_(Cards, Swaps1, Swaps)
    ).

main :-
    foreach(
        ( between(1, 10, N), topswops(N, MaximumSwaps) ),
        format("~w: ~w~n", [N, MaximumSwaps])
    ).
