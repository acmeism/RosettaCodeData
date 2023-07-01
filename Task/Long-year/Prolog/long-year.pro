% See https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year

p(Year, P):-
    P is (Year + (Year//4) - (Year//100) + (Year//400)) mod 7.

long_year(Year):-
    p(Year, 4),
    !.
long_year(Year):-
    Year_before is Year - 1,
    p(Year_before, 3).

print_long_years(From, To):-
    writef("Long years between %w and %w:\n", [From, To]),
    print_long_years(From, To, 0),
    nl.

print_long_years(From, To, _):-
    From > To,
    !.
print_long_years(From, To, Count):-
    long_year(From),
    !,
    (Count > 0 ->
        (0 is Count mod 10 -> nl ; write(' '))
        ;
        true
    ),
    write(From),
    Count1 is Count + 1,
    Next is From + 1,
    print_long_years(Next, To, Count1).
print_long_years(From, To, Count):-
    Next is From + 1,
    print_long_years(Next, To, Count).

main:-
     print_long_years(1800, 2100).
