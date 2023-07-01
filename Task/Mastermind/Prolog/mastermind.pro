mastermind :- mastermind(7, 4, 8, no_duplicates).

mastermind(Colours, Length, Guesses, Duplicates) :-
	between(2, 20, Colours),
	between(4, 10, Length),
	between(7, 20, Guesses),
	member(Duplicates, [allow_duplicates, no_duplicates]),

	create_board(Colours, Length, Duplicates, Board),
	intro(Colours, Length, Duplicates),
	play(board(Board, Length, Colours, Guesses), [], 0), !.

intro(Colours, Length, Duplicates) :-
	format('Guess the code!~n'),
	format('There are ~p character types, and ~p letters to guess~n',
	    [Colours, Length]),
	Duplicates = allow_duplicates
	-> format('Duplicates are allowed~n~n')
	; format('Duplicates are not allowed~n~n').

/* Create the combination to be guessed */
create_board(Colours, Length, Duplicates, Board) :-
	length(Board, Length),
	valid_char_list(Colours, CharSet),
	repeat,
	maplist(random_alpha(CharSet), Board),
	check_for_duplicates(Board, Duplicates).

check_for_duplicates(_, allow_dupicates).
check_for_duplicates(Board, no_duplicates) :- is_set(Board).

/* Main loop - get the player guess and print out status */
play(board(Board,_,_,MaxGuesses), _, MaxGuesses) :-
	write('Sorry, You failed to guess in time...!\nThe code was : '),
	maplist(write, Board),
	nl.
play(BoardData, PrevGuesses, GuessNum) :-
	BoardData = board(_, Length, Colours, MaxGuesses),
	GuessNum < MaxGuesses,
	ReportedGuess is GuessNum + 1,
	format('Guess #~p of #~p: ', [ReportedGuess, MaxGuesses]),
	get_player_guess(Length, Colours, Guess),
	evaluate_and_print_result(BoardData, PrevGuesses, ReportedGuess, Guess).

evaluate_and_print_result(board(Board,_,_,_), _, _,Board) :-
	format('Well done! You Guessed Correctly.~n').
evaluate_and_print_result(BoardData, PrevGuesses, NextGuessNum, Guess) :-
	BoardData = board(Board, _, _, _),
	dif(Board, Guess),
	match_guess_to_board(Board, Guess, Diffs),
	append(PrevGuesses, [guess(NextGuessNum, Guess, Diffs)], Guesses),
	maplist(print_guess, Guesses),
	play(BoardData, Guesses, NextGuessNum).

/* Get the player guess and validate that it matches the rules */
get_player_guess(Length, Colours, Guess) :-
	repeat,
	read_line_to_string(user_input, Line),
	string_chars(Line, Guess),

	% validate the correct number of items have been entered
	length(Guess, Length),

	% validate that all the characters are valid for the number of colours
	valid_char_list(Colours, ValidCharSet),
	subset(Guess, ValidCharSet).

/* Predicates to figure out how many places are correct */
match_guess_to_board(Board, Guess, Matches) :-
	maplist(guess_differences(Board), Board, Guess, Differences),
	sort(0, @>=, Differences, Matches).

% Same position, same type
guess_differences(_Board, B, B, 'X').
% Same type, different position
guess_differences(Board, B, G, 'O') :- dif(B, G), member(G, Board).
% Type not on board
guess_differences(Board, B, G, '-') :- dif(B, G), \+ member(G, Board).

/* Print out the current progress */
print_guess(guess(NextGuessNumber, Guess, Differences))	:-
	format('~w: ', NextGuessNumber),
	maplist(format('~w '), Guess),
	format(' : '),
	maplist(format('~w '), Differences),
	nl.

/* Utils */
alpha_chars([a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t]).

valid_char_list(Colours, CharSet) :-
	alpha_chars(AllChars),
	truncate_list(AllChars, Colours, CharSet).

random_alpha(AllChars, RandomMember) :- random_member(RandomMember, AllChars).

truncate_list(_, 0, []).
truncate_list([A|T], N, [A|R]) :-
	N > 0,
	N1 is N - 1,
	truncate_list(T, N1, R).
