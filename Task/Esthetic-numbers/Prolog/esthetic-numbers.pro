main:-
    forall(between(2, 16, Base),
            (Min_index is Base * 4, Max_index is Base * 6,
            print_esthetic_numbers1(Base, Min_index, Max_index))),
    print_esthetic_numbers2(1000, 9999, 16),
    nl,
    print_esthetic_numbers2(100000000, 130000000, 8).

print_esthetic_numbers1(Base, Min_index, Max_index):-
    swritef(Format, '~%tr ', [Base]),
    writef('Esthetic numbers in base %t from index %t through index %t:\n',
            [Base, Min_index, Max_index]),
    print_esthetic_numbers1(Base, Format, Min_index, Max_index, 0, 1).

print_esthetic_numbers1(Base, Format, Min_index, Max_index, M, I):-
    I =< Max_index,
    !,
    next_esthetic_number(Base, M, N),
    (I >= Min_index -> format(Format, [N]) ; true),
    J is I + 1,
    print_esthetic_numbers1(Base, Format, Min_index, Max_index, N, J).
print_esthetic_numbers1(_, _, _, _, _, _):-
    write('\n\n').

print_esthetic_numbers2(Min, Max, Per_line):-
    writef('Esthetic numbers in base 10 between %t and %t:\n', [Min, Max]),
    M is Min - 1,
    print_esthetic_numbers2(Max, Per_line, M, 0).

print_esthetic_numbers2(Max, Per_line, M, Count):-
    next_esthetic_number(10, M, N),
    N =< Max,
    !,
    write(N),
    Count1 is Count + 1,
    (0 is Count1 mod Per_line -> nl ; write(' ')),
    print_esthetic_numbers2(Max, Per_line, N, Count1).
print_esthetic_numbers2(_, _, _, Count):-
    writef('\nCount: %t\n', [Count]).

next_esthetic_number(Base, M, N):-
    N is M + 1,
    N < Base,
    !.
next_esthetic_number(Base, M, N):-
    A is M // Base,
    B is A mod Base,
    (B is M mod Base + 1, B + 1 < Base ->
        N is M + 2
        ;
        next_esthetic_number(Base, A, C),
        D is C mod Base,
        (D == 0 -> E = 1 ; E is D - 1),
        N is C * Base + E).
