consolidate_ranges(Ranges, Consolidated):-
    normalize(Ranges, Normalized),
    sort(Normalized, Sorted),
    merge(Sorted, Consolidated).

normalize([], []):-!.
normalize([r(X, Y)|Ranges], [r(Min, Max)|Normalized]):-
    (X > Y -> Min = Y, Max = X; Min = X, Max = Y),
    normalize(Ranges, Normalized).

merge([], []):-!.
merge([Range], [Range]):-!.
merge([r(Min1, Max1), r(Min2, Max2)|Rest], Merged):-
    Min2 =< Max1,
    !,
    Max is max(Max1, Max2),
    merge([r(Min1, Max)|Rest], Merged).
merge([Range|Ranges], [Range|Merged]):-
    merge(Ranges, Merged).

write_range(r(Min, Max)):-
    writef('[%w, %w]', [Min, Max]).

write_ranges([]):-!.
write_ranges([Range]):-
    !,
    write_range(Range).
write_ranges([Range|Ranges]):-
    write_range(Range),
    write(', '),
    write_ranges(Ranges).

test_case([r(1.1, 2.2)]).
test_case([r(6.1, 7.2), r(7.2, 8.3)]).
test_case([r(4, 3), r(2, 1)]).
test_case([r(4, 3), r(2, 1), r(-1, -2), r(3.9, 10)]).
test_case([r(1, 3), r(-6, -1), r(-4, -5), r(8, 2), r(-6, -6)]).

main:-
    forall(test_case(Ranges),
           (consolidate_ranges(Ranges, Consolidated),
            write_ranges(Ranges), write(' -> '),
            write_ranges(Consolidated), nl)).
