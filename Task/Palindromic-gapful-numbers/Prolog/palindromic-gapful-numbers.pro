init_palindrome(Digit, p(10, Next, 0)):-
    Next is Digit * 10 - 1.

next_palindrome(Digit, p(Power, Next, Even), p(Power1, Next2, Even1), Palindrome):-
    Next1 is Next + 1,
    (Next1 is Power * (Digit + 1) ->
        (Even == 1 -> Power1 is Power * 10 ; Power1 = Power),
        Next2 is Digit * Power1,
        Even1 is 1 - Even
        ;
        Power1 = Power,
        Next2 = Next1,
        Even1 = Even
    ),
    (Even1 == 1 ->
        X is 10 * Power1, Y = Next2
        ;
        X = Power1, Y is Next2 // 10
    ),
    reverse_number(Y, Z),
    Palindrome is Next2 * X + Z.

reverse_number(N, R):-
    reverse_number(N, 0, R).

reverse_number(0, Result, Result):-
    !.
reverse_number(N, R, Result):-
    R1 is R * 10 + N mod 10,
    N1 is N // 10,
    reverse_number(N1, R1, Result).

is_gapful(N):-
    is_gapful(N, N).

is_gapful(N, M):-
    M < 10,
    !,
    0 is N mod (N mod 10 + 10 * (M mod 10)).
is_gapful(N, M):-
    M1 is M // 10,
    is_gapful(N, M1).

find_palindromic_gapful_numbers(N, List):-
    find_palindromic_gapful_numbers(N, 1, List).

find_palindromic_gapful_numbers(_, 10, []):-
    !.
find_palindromic_gapful_numbers(N, Digit, [Numbers|Rest]):-
    find_palindromic_gapful_numbers1(Digit, N, Numbers),
    Next_digit is Digit + 1,
    find_palindromic_gapful_numbers(N, Next_digit, Rest).

find_palindromic_gapful_numbers1(Digit, N, List):-
    init_palindrome(Digit, P),
    find_palindromic_gapful_numbers1(Digit, P, N, 0, List).

find_palindromic_gapful_numbers1(_, _, N, N, []):-
    !.
find_palindromic_gapful_numbers1(Digit, P, N, Count, List):-
    next_palindrome(Digit, P, P_next, Palindrome),
    (is_gapful(Palindrome) ->
        Count1 is Count + 1,
        List = [Palindrome|Rest]
        ;
        Count1 = Count,
        List = Rest
    ),
    find_palindromic_gapful_numbers1(Digit, P_next, N, Count1, Rest).

print_numbers(First, Last, Numbers):-
    (First == 1 ->
        writef("First %w palindromic gapful numbers ending in:\n", [Last])
        ;
        Count is Last - First + 1,
        writef("Last %w of first %w palindromic gapful numbers ending in:\n", [Count, Last])
    ),
    print_numbers(First, Last, 1, Numbers),
    nl.

print_numbers(_, _, 10, _):-
    !.
print_numbers(First, Last, Digit, [N|Numbers]):-
    writef("%w:", [Digit]),
    print_numbers1(First, Last, 1, N),
    Next_digit is Digit + 1,
    print_numbers(First, Last, Next_digit, Numbers).

print_numbers1(_, Last, I, _):-
    I > Last,
    nl,
    !.
print_numbers1(First, Last, I, [_|Numbers]):-
    I < First,
    !,
    J is I + 1,
    print_numbers1(First, Last, J, Numbers).
print_numbers1(First, Last, I, [N|Numbers]):-
    writef(" %w", [N]),
    J is I + 1,
    print_numbers1(First, Last, J, Numbers).

main:-
    find_palindromic_gapful_numbers(1000, Numbers),
    print_numbers(1, 20, Numbers),
    print_numbers(86, 100, Numbers),
    print_numbers(991, 1000, Numbers).
