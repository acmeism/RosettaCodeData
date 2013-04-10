:- module('ia.pl', [tirage/1]).
:- use_module(library(clpfd)).

% to store the previous guesses and the answers
:- dynamic guess/2.

% parameters of the engine

% length of the guess
proposition(4).

% Numbers of digits
% 0 -> 8
digits(8).


% tirage(-)
tirage(Ms) :-
	% are there previous guesses ?
	(  bagof([P, R], guess(P,R), Propositions)
	->  tirage(Propositions, Ms)
	;   % First try
	    tirage_1(Ms)),
	!.

% tirage_1(-)
% We choose the first Len numbers
tirage_1(L):-
	proposition(Len),
	Max is Len-1,
	numlist(0, Max, L).


% tirage(+,-)
tirage(L, Ms) :-
	proposition(Len),
        length(Ms, Len),

	digits(Digits),

	% The guess continas only this numbers
        Ms ins 0..Digits,
	all_different(Ms),

	% post the constraints
        maplist(placees(Ms), L),

	% compute a possible solution
	label(Ms).

% placees(+, +])
placees(Sol, [Prop, [BP, MP]]) :-
	V #= 0,

	% compute the numbers of digits in good places
	compte_bien_placees(Sol, Prop, V, BP1),
	BP1 #= BP,

	% compute the numbers of digits inbad places
	compte_mal_placees(Sol, Prop, 0, V, MP1),
	MP1 #= MP.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% compte_mal_placees(+, +, +, +, -).
% @arg1 : guess to create
% @arg2 : guess already used
% @arg3 : range of the first digit of the previuos arg
% @arg4 : current counter of the digit in bad places
% @arg5 : final counter of the digit in bad places
%
%
compte_mal_placees(_, [], _, MP, MP).

compte_mal_placees(Sol, [H | T], N, MPC, MPF) :-
	compte_une_mal_placee(H, N, Sol, 0,  0, VF),
	MPC1 #= MPC + VF,
	N1 is N+1,
	compte_mal_placees(Sol, T, N1, MPC1, MPF).


% Here we check one digit of an already done guess
% compte_une_mal_placee(+, +, +, +, -).
% @arg1 : the digit
% @arg2 : range of this digit
% @arg3 : guess to create
%         we check each digit of this guess
% @arg4 : range of the digit of this guess
% @arg5 : current counter of the digit in bad places
% @arg6 : final counter of the digit in bad places
%
compte_une_mal_placee(_H, _N, [], _, TT, TT).

% digit in the same range, continue
compte_une_mal_placee(H, NH, [_H1 | T], NH, TTC, TTF) :-
	NH1 is NH + 1, !,
	compte_une_mal_placee(H, NH, T, NH1, TTC, TTF).

% same digit in different places
% increment the counter and continue continue
compte_une_mal_placee(H, NH, [H1 | T], NH1, TTC, TTF) :-
	H #= H1,
	NH \= NH1,
	NH2 is NH1 + 1,
	TTC1 #= TTC + 1,
	compte_une_mal_placee(H, NH, T, NH2, TTC1, TTF).

compte_une_mal_placee(H, NH, [H1 | T], NH1, TTC, TTF) :-
	H #\= H1,
	NH2 is NH1 + 1,
	compte_une_mal_placee(H, NH, T, NH2, TTC, TTF).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% compte_bien_placees(+, +, +, -)
% @arg1 : guess to create
% @arg2 : previous guess
% @arg3 : current counter of the digit in good places
% @arg4 : final counter of the digit in good places
%
%
compte_bien_placees([], [], MP, MP).

compte_bien_placees([H | T], [H1 | T1], MPC, MPF) :-
	H #= H1,
	MPC1 #= MPC + 1,
	compte_bien_placees(T, T1, MPC1, MPF).

compte_bien_placees([H | T], [H1 | T1], MPC, MPF) :-
	H #\= H1,
	compte_bien_placees(T, T1, MPC, MPF).
