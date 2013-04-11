happy_numbers(L, Nb) :-
    % creation of the list
    length(L, Nb),
    % Process of this list
    get_happy_number(L, 1).


% the game is over
get_happy_number([], _).

% querying the newt happy_number
get_happy_number([H | T], N) :-
     N1 is N+1,
    (is_happy_number(N) ->
        H = N,
        get_happy_number(T, N1);
        get_happy_number([H | T], N1)).

% we must memorized the numbers reached
is_happy_number(N) :-
    is_happy_number(N, [N]).

% a number is happy when we get 1
is_happy_number(N, _L) :-
    get_next_number(N, 1), !.

% or when this number is not already reached !
is_happy_number(N, L) :-
    get_next_number(N, NN),
    \+member(NN, L),
    is_happy_number(NN, [NN | L]).

% Process of the next number from N
get_next_number(N, NewN) :-
    get_list_digits(N, LD),
    maplist(square, LD, L),
    sumlist(L, NewN).

get_list_digits(N, LD) :-
	number_chars(N, LCD),
	maplist(number_chars_, LD, LCD).

number_chars_(D, CD) :-
	number_chars(D, [CD]).

square(N, SN) :-
	SN is N * N.
