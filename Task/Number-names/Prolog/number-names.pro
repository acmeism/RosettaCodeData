:- module(spell, [spell/2]).

%
% spell numbers up to the nonillions.
%

ones(1, "one").  ones(2, "two").    ones(3, "three").  ones(4, "four").  ones( 5, "five").
ones(6, "six").  ones(7, "seven").  ones(8, "eight").  ones(9, "nine").  ones(10, "ten").

ones(11, "eleven").     ones(12, "twelve").    ones(13, "thirteen").
ones(14, "fourteen").   ones(15, "fifteen").   ones(16, "sixteen").
ones(17, "seventeen").  ones(18, "eighteen").  ones(19, "nineteen").

tens(2, "twenty").  tens(3, "thirty").  tens(4, "forty").   tens(5, "fifty").
tens(6, "sixty").   tens(7, "seventy"). tens(8, "eighty").  tens(9, "ninety").

group( 1, "thousand").   group( 2, "million").      group(3, "bilion").
group( 4, "trillion").   group( 5, "quadrillion").  group(6, "quintillion").
group( 7, "sextilion").  group( 8, "septillion").   group(9, "octillion").
group(10, "nonillion").  group(11, "decillion").

spellgroup(N, G) :- G is floor(log10(N) / 3).

spell(N, S) :-
    N < 0, !,
    NegN is -N, spell(NegN, S0),
    string_concat("negative ", S0, S).
spell(0, "zero") :- !.
spell(N, S) :- between(1, 19, N), ones(N, S), !.
spell(N, S) :-
    N < 100, !,
    divmod(N, 10, Tens, Ones),
    tens(Tens, StrTens), ones_part(Ones, StrOnes),
    string_concat(StrTens, StrOnes, S).
spell(N, S) :-
    N < 1000, !,
    divmod(N, 100, Hundreds, Tens),
    ones(Hundreds, H), string_concat(H, " hundred", StrHundreds),
    tens_part(Tens, StrTens),
    string_concat(StrHundreds, StrTens, S).
spell(N, S) :-
    spellgroup(N, G), group(G, StrG),
    M is 10**(3*G), divmod(N, M, Group, Rest),
    spell(Group, S1),
    spell_remaining(Rest, S2),
    format(string(S), "~w ~w~w", [S1, StrG, S2]).

ones_part(0, "") :- !.
ones_part(N, S) :-
    ones(N, StrN),
    string_concat("-", StrN, S).

tens_part(0, "") :- !.
tens_part(N, S) :-
    spell(N, Tens),
    string_concat(" and ", Tens, S).

spell_remaining(0, "") :- !.
spell_remaining(N, S) :-
    spell(N, Rest),
    string_concat(", ", Rest, S).
