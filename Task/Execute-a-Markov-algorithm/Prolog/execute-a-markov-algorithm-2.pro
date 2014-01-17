:- use_module('markov.pl').
:- use_module(library(lambda)).

markov :-
	maplist(\X^(call(X), nl,nl), [markov_1, markov_2, markov_3, markov_4, markov_5]).

markov_1 :-
	A = ['# This rules file is extracted from Wikipedia:',
	     '# http://en.wikipedia.org/wiki/Markov_Algorithm',
	     'A -> apple',
	     'B -> bag',
	     'S -> shop',
	     'T -> the',
	     'the shop -> my brother',
	     'a never used -> .terminating rule'],
	B = 'I bought a B of As from T S.',
	apply_markov(A, B, R),
	writeln(B),
	writeln(R).


markov_2 :-
	A = ['# Slightly modified from the rules on Wikipedia',
	     'A -> apple',
	     'B -> bag',
	     'S -> .shop',
	     'T -> the',
	     'the shop -> my brother',
	     'a never used -> .terminating rule'],

	B = 'I bought a B of As from T S.',

	apply_markov(A, B, R),
	writeln(B),
	writeln(R).


markov_3 :-
	A = ['# BNF Syntax testing rules',
	     'A -> apple',
	     'WWWW -> with',
	     'Bgage -> ->.*',
	     'B -> bag',
	     '->.* -> money',
	     'W -> WW',
	     'S -> .shop',
	     'T -> the',
	     'the shop -> my brother',
	     'a never used -> .terminating rule'],

	B = 'I bought a B of As W my Bgage from T S.',

	apply_markov(A, B, R),
	writeln(B),
	writeln(R).


markov_4 :-
	A = ['### Unary Multiplication Engine, for testing Markov Algorithm implementations',
	     '### By Donal Fellows.',
	     '# Unary addition engine',
	     '_+1 -> _1+',
	     '1+1 -> 11+',
	     '# Pass for converting from the splitting of multiplication into ordinary',
	     '# addition',
	     '1! -> !1',
	     ',! -> !+',
	     '_! -> _',
	     '# Unary multiplication by duplicating left side, right side times',
	     '1*1 -> x,@y',
	     '1x -> xX',
	     'X, -> 1,1',
	     'X1 -> 1X',
	     '_x -> _X',
	     ',x -> ,X',
	     'y1 -> 1y',
	     'y_ -> _',
	     '# Next phase of applying',
	     '1@1 -> x,@y',
	     '1@_ -> @_',
	     ',@_ -> !_',
	     '++ -> +',
	     '# Termination cleanup for addition',
	     '_1 -> 1',
	     '1+_ -> 1',
	     '_+_ -> '],

	B =  '_1111*11111_',

	apply_markov(A, B, R),
	writeln(B),
	writeln(R).

markov_5 :-
	A = ['# Turing machine: three-state busy beaver',
	     '#',
	     '# state A, symbol 0 => write 1, move right, new state B',
	     'A0 -> 1B',
	     '# state A, symbol 1 => write 1, move left, new state C',
	     '0A1 -> C01',
	     '1A1 -> C11',
	     '# state B, symbol 0 => write 1, move left, new state A',
	     '0B0 -> A01',
	     '1B0 -> A11',
	     '# state B, symbol 1 => write 1, move right, new state B',
	     'B1 -> 1B',
	     '# state C, symbol 0 => write 1, move left, new state B',
	     '0C0 -> B01',
	     '1C0 -> B11',
	     '# state C, symbol 1 => write 1, move left, halt',
	     '0C1 -> H01',
	     '1C1 -> H11'],

	B = '000000A000000',
	apply_markov(A, B, R),
	writeln(B),
	writeln(R).
