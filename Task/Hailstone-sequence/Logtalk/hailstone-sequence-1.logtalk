:- object(hailstone).

	:- public(generate_sequence/2).
	:- mode(generate_sequence(+natural, -list(natural)), zero_or_one).
	:- info(generate_sequence/2, [
		comment is 'Generates the Hailstone sequence that starts with its first argument. Fails if the argument is not a natural number.',
		argnames is ['Start', 'Sequence']
	]).

	:- public(write_sequence/1).
	:- mode(write_sequence(+natural), zero_or_one).
	:- info(write_sequence/1, [
		comment is 'Writes to the standard output the Hailstone sequence that starts with its argument. Fails if the argument is not a natural number.',
		argnames is ['Start']
	]).

	:- public(sequence_length/2).
	:- mode(sequence_length(+natural, -natural), zero_or_one).
	:- info(sequence_length/2, [
		comment is 'Calculates the length of the Hailstone sequence that starts with its first argument. Fails if the argument is not a natural number.',
		argnames is ['Start', 'Length']
	]).

	:- public(longest_sequence/4).
	:- mode(longest_sequence(+natural, +natural, -natural, -natural), zero_or_one).
	:- info(longest_sequence/4, [
		comment is 'Calculates the longest Hailstone sequence in the interval [Start, End]. Fails if the interval is not valid.',
		argnames is ['Start', 'End', 'N', 'Length']
	]).

	generate_sequence(Start, Sequence) :-
		integer(Start),
		Start >= 1,
		sequence(Start, Sequence).

	sequence(1, [1]) :-
		!.
	sequence(N, [N| Sequence]) :-
		(	N mod 2 =:= 0 ->
			M is N // 2
		;	M is (3 * N) + 1
		),
		sequence(M, Sequence).

	write_sequence(Start) :-
		integer(Start),
		Start >= 1,
		sequence(Start).

	sequence(1) :-
		!,
		write(1), nl.
	sequence(N) :-
		write(N), write(' '),
		(	N mod 2 =:= 0 ->
			M is N // 2
		;	M is (3 * N) + 1
		),
		sequence(M).

	sequence_length(Start, Length) :-
		integer(Start),
		Start >= 1,
		sequence_length(Start, 1, Length).

	sequence_length(1, Length, Length) :-
		!.
	sequence_length(N, Length0, Length) :-
		Length1 is Length0 + 1,
		(	N mod 2 =:= 0 ->
			M is N // 2
		;	M is (3 * N) + 1
		),
		sequence_length(M, Length1, Length).

	longest_sequence(Start, End, N, Length) :-
		integer(Start),
		integer(End),
		Start >= 1,
		Start =< End,
		longest_sequence(Start, End, 1, N, 1, Length).

	longest_sequence(Current, End, N, N, Length, Length) :-
		Current > End,
		!.
	longest_sequence(Current, End, N0, N, Length0, Length) :-
		sequence_length(Current, 1, CurrentLength),
		Next is Current + 1,
		(	CurrentLength > Length0 ->
			longest_sequence(Next, End, Current, N, CurrentLength, Length)
		;	longest_sequence(Next, End, N0, N, Length0, Length)
		).

:- end_object.
