%____________________________________________________________________
% Implements the American soundex algorithm
%   as described at https://en.wikipedia.org/wiki/Soundex
%  In SWI Prolog, a 'string' is specified in 'single quotes',
%    while a "list of codes" may be specified in "double quotes".
%  So, "abc" is equivalent to [97, 98, 99], while
%    'abc' = abc  (an atom), and 'Abc' is also an atom.  There are
%    conversion methods that can produce lists of characters:
%        ?- atom_chars('Abc', X).
%	 X = ['A', b, c].
%    or lists of codes (mapping to unicode code points):
%        ?- atom_codes('Abc', X).
%        X = [65, 98, 99].
%    and the conversion predicates are bidirectional.
%        ?- atom_codes(A, [65, 98, 99]).
%        A = 'Abc'.
%  A single character code may be specified as 0'C, where C is the
%    character you want to convert to a code.
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

%  Relates groups of consonants to representative digits
creplace(Ch, 0'1) :- member(Ch, "bfpv").
creplace(Ch, 0'2) :- member(Ch, "cgjkqsxz").
creplace(Ch, 0'3) :- member(Ch, "dt").
creplace(0'l, 0'4).
creplace(Ch, 0'5) :- member(Ch, "mn").
creplace(0'r, 0'6).

% strips elements contained in <Set> from a string
strip(Set, [H|T], Tr) :- memberchk(H, Set), !, strip(Set, T, Tr).
strip(Set, [H|T], [H|Tr]) :- !, strip(Set, T, Tr).
strip(_, [], []).

% Replace consonants with appropriate digits
consonants([H|T], [Ch|Tr]) :- creplace(H, Ch), !, consonants(T, Tr).
consonants([H|T], [H|Tr]) :- !, consonants(T, Tr).
consonants([], []).

% Replace adjacent digits with single digit
adjacent([Ch, Ch|T], [Ch|Tr]) :- between(0'0, 0'9, Ch), !, adjacent(T, Tr).
adjacent([H|T], [H|Tr]) :- !, adjacent(T, Tr).
adjacent([], []).

% Replace first character with original one if its a digit
chk_digit([H,D|T], [H|T]) :- between(0'0, 0'9, D), !.
chk_digit([_,H|T], [H|T]).

% Faithul representation of soundex rules:
%   1: Save 1st letter, strip "hw"
%   2: Replace consonants with appropriate digits
%   3: Replace adjacent digits with single occurrence
%   4: Remove vowels except 1st letter
%   5: If 1st symbol is a digit, replace it with saved 1st letter
%   6: Ensure trailing zeroes
do_soundex([H|T], Res) :-
	strip("hw", T, Ts), consonants([H|Ts], Tc),
	adjacent(Tc, [C|Ta]), strip("aeiouy", Ta, Tv),
	chk_digit([H,C|Tv], Td), append(Td, "0000", Tr),
	atom_codes(Tf, Tr), sub_string(Tf, 0, 4, _, Res).

% Prepare string, convert to lower case and do the soundex alogorithm
soundex(Text, Res) :-
	downcase_atom(Text, Lower), atom_codes(Lower, T),
	do_soundex(T, Res).

% Perform tests to check that the right values are produced
test(S,V) :- not(soundex(S,V)), writef('%w failed\n', [S]).
test :- test('Robert', 'r163'), !, fail.
test :- test('Rupert', 'r163'), !, fail.
test :- test('Rubin', 'r150'), !, fail.
test :- test('Ashcroft', 'a261'), !, fail.
test :- test('Ashcraft', 'a261'), !, fail.
test :- test('Tymczak', 't522'), !, fail.
test :- test('Pfister', 'p236'), !, fail.
test.  % Succeeds only if all the tests succeed
