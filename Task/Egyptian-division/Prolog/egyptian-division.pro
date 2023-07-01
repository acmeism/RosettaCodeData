egyptian_divide(Dividend, Divisor, Quotient, Remainder):-
    powers2_multiples(Dividend, [1], Powers, [Divisor], Multiples),
    accumulate(Dividend, Powers, Multiples, 0, Quotient, 0, Acc),
    Remainder is Dividend - Acc.

powers2_multiples(Dividend, Powers, Powers, Multiples, Multiples):-
    Multiples = [M|_],
    2 * M > Dividend,
    !.
powers2_multiples(Dividend, [Power|P], Powers, [Multiple|M], Multiples):-
    Power2 is 2 * Power,
    Multiple2 is 2 * Multiple,
    powers2_multiples(Dividend, [Power2,Power|P], Powers,
                      [Multiple2, Multiple|M], Multiples).

accumulate(_, [], [], Ans, Ans, Acc, Acc):-!.
accumulate(Dividend, [P|Powers], [M|Multiples], Ans1, Answer, Acc1, Acc):-
    Acc1 + M =< Dividend,
    !,
    Acc2 is Acc1 + M,
    Ans2 is Ans1 + P,
    accumulate(Dividend, Powers, Multiples, Ans2, Answer, Acc2, Acc).
accumulate(Dividend, [_|Powers], [_|Multiples], Ans1, Answer, Acc1, Acc):-
    accumulate(Dividend, Powers, Multiples, Ans1, Answer, Acc1, Acc).

test_egyptian_divide(Dividend, Divisor):-
    egyptian_divide(Dividend, Divisor, Quotient, Remainder),
    writef('%w / %w = %w, remainder = %w\n', [Dividend, Divisor,
           Quotient, Remainder]).

main:-
    test_egyptian_divide(580, 34).
