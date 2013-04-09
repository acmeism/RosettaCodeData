:- module('bt_mult.pl', [op(850, xfx, btmult),
			 btmult/2,
			 multiplication/3
			]).

:- use_module('bt_add.pl').

:- op(850, xfx, btmult).
A is B btmult C :-
	multiplication(B, C, A).

neg(A, B) :-
	maplist(opp, A, B).

opp(48, 48).
opp(45, 43).
opp(43, 45).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% the multiplication (efficient)
% multiplication(+BIn, +QIn, -AOut)
% Aout is BIn * QIn
% BIn, QIn, AOut are strings
multiplication(BIn, QIn, AOut) :-
	string_to_list(BIn, B),
	string_to_list(QIn, Q),

	% We work with positive numbers
	(   B = [45 | _] -> Pos0 = false, neg(B,BP) ; BP = B, Pos0 = true),
	(   Q = [45 | _] -> neg(Q, QP), select(Pos0, [true, false], [Pos1]); QP = Q, Pos1 = Pos0),

	multiplication_(BP, QP, [48], A),
	(   Pos1 = false -> neg(A, A1); A1 = A),
	string_to_list(AOut, A1).


multiplication_(_B, [], A, A).

multiplication_(B, [H | T], A, AF) :-
	multiplication_1(B, H, B1),
	append(A, [48], A1),
	bt_add1(B1, A1, A2),
	multiplication_(B, T, A2, AF).

% by 1 (digit '+' code 43)
multiplication_1(B, 43, B).

% by 0 (digit '0' code 48)
multiplication_1(_, 48, [48]).

% by -1 (digit '-' code 45)
multiplication_1(B, 45, B1) :- neg(B, B1).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% the division (efficient)
% division(+AIn, +BIn, -QOut, -ROut)
%
division(AIn, BIn, QOut, ROut) :-
	string_to_list(AIn, A),
	string_to_list(BIn, B),
	length(B, LB),
	length(A, LA),
	Len is LA - LB,
	(   Len < 0 -> Q = [48], R = A
	;   neg(B, NegB), division_(A, B, NegB, LB, Len, [], Q, R)),
	string_to_list(QOut, Q),
	string_to_list(ROut, R).


division_(A, B, NegB, LenB, LenA, QC, QF, R) :-
	% if the remainder R is negative (last number A), we must decrease the quotient Q, annd add B to R
	(   LenA = -1 -> (A = [45 | _]  -> positive(A, B, QC, QF, R) ;	QF = QC, A = R)
	;   extract(LenA, _, A, AR, AF),
	    length(AR, LR),

	    (	LR >= LenB -> ( AR = [43 | _] ->
			        bt_add1(AR, NegB, S), Q0 = [43],
				% special case : R has the same length than B
				% and his first digit is + (1)
				% we must do another one substraction
				(   (length(S, LenB), S = [43|_]) ->
				                       bt_add1(S, NegB, S1),
				                       bt_add1(QC, [43], QC1),
				                       Q00 = [45]
				;   S1 = S, QC1 = QC, Q00 = Q0)


	                        ; bt_add1(AR, B, S1), Q00 = [45], QC1 = QC),
				append(QC1, Q00, Q1),
		                append(S1, AF, A1),
				strip_nombre(A1, A2, []),
				LenA1 is LenA - 1,
				division_(A2, B, NegB, LenB, LenA1, Q1, QF, R)

	    ;   append(QC, [48], Q1), LenA1 is LenA - 1,
	        division_(A, B, NegB, LenB, LenA1, Q1, QF, R))).

% extract(+Len, ?N1, +L, -Head, -Tail)
% remove last N digits from the list L
% put them in Tail.
extract(Len, Len, [], [], []).

extract(Len, N1, [H|T], AR1, AF1) :-
	extract(Len, N, T, AR, AF),
	N1 is N-1,
	(   N > 0 -> AR = AR1, AF1 = [H | AF]; AR1 = [H | AR], AF1 = AF).



positive(R, _, Q, Q, R) :- R = [43 | _].

positive(S, B, Q, QF, R ) :-
	bt_add1(S, B, S1),
	bt_add1(Q, [45], Q1),
	positive(S1, B, Q1, QF, R).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% "euclidian" division (inefficient)
% euclide(?A, +BIn, ?Q, ?R)
% A = B * Q + R
euclide(A, B, Q, R) :-
	mult(A, B, Q, R).


mult(AIn, BIn, QIn, RIn) :-
	(   nonvar(AIn) -> string_to_list(AIn, A); A = AIn),
	(   nonvar(BIn) -> string_to_list(BIn, B); B = BIn),
	(   nonvar(QIn) -> string_to_list(QIn, Q); Q = QIn),
	(   nonvar(RIn) -> string_to_list(RIn, R); R = RIn),

	% we use positive numbers
	(   B = [45 | _] -> Pos0 = false, neg(B,BP) ; BP = B, Pos0 = true),
	(   (nonvar(Q), Q = [45 | _]) -> neg(Q, QP), select(Pos0, [true, false], [Pos1])
	;   nonvar(Q) -> Q = QP , Pos1 = Pos0
	;   Pos1 = Pos0),
	(   (nonvar(A), A = [45 | _]) -> neg(A, AP)
	;   nonvar(A) -> AP = A
	;   true),

	% is R instancied ?
	( nonvar(R) -> R1 = R; true),
	% multiplication ? we add B to A and substract 1 (digit '-') to Q
	(   nonvar(Q) -> BC = BP, Ajout = [45],
	    (	nonvar(R) ->  bt_add1(BC, R, AP) ; AP = BC)
	% division ? we substract B to A and add 1 (digit '+') to Q
	;    neg(BP, BC), Ajout = [43], QP = [48]),

	% do the real job
	mult_(BC, QP, AP, R1, Resultat, Ajout),

	(   var(QIn) -> (Pos1 = false -> neg(Resultat, QT); Resultat = QT), string_to_list(QIn, QT)
	;   true),
	(   var(AIn) -> (Pos1 = false -> neg(Resultat, AT); Resultat = AT), string_to_list(AIn, AT)
	;   true),
	(   var(RIn) -> string_to_list(RIn, R1); true).

% @arg1 : divisor
% @arg2 : quotient
% @arg3 : dividend
% @arg4 : remainder
% @arg5 : Result :  receive either the dividend A
%                           either the quotient Q
mult_(B, Q, A, R, Resultat, Ajout) :-
	bt_add1(Q, Ajout, Q1),
	bt_add1(A, B, A1),
	(  Q1 = [48] -> Resultat = A % a multiplication
	;  ( A1 = [45 | _], Ajout = [43]) -> Resultat = Q, R = A  % a division
	;  mult_(B, Q1, A1, R, Resultat, Ajout)) .
