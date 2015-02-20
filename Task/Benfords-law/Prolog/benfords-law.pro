%_________________________________________________________________
% Does the Fibonacci sequence follow Benford's law?
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Fibonacci sequence generator
fib(C, [P,S], C, N)  :- N is P + S.
fib(C, [P,S], Cv, V) :- succ(C, Cn), N is P + S, !, fib(Cn, [S,N], Cv, V).

fib(0, 0).
fib(1, 1).
fib(C, N) :- fib(2, [0,1], C, N). % Generate from 3rd sequence on

% The benford law calculated
benford(D, Val) :- Val is log10(1+1/D).

% Retrieves the first characters of the first 1000 fibonacci numbers
%        (excluding zero)
firstchar(V) :-
	fib(C,N), N =\= 0, atom_chars(N, [Ch|_]), number_chars(V, [Ch]),
	(C>999-> !; true).

% Increment the n'th list item (1 based), result -> third argument.
incNth(1, [Dh|Dt], [Ch|Dt]) :- !, succ(Dh, Ch).
incNth(H, [Dh|Dt], [Dh|Ct]) :- succ(Hn, H), !, incNth(Hn, Dt, Ct).

% Calculate the frequency of the all the list items
freq([], D, D).
freq([H|T], D, C) :- incNth(H, D, L), !, freq(T, L, C).

freq([H|T], Freq) :-
	length([H|T], Len), min_list([H|T], Min), max_list([H|T], Max),
	findall(0, between(Min,Max,_), In),
	freq([H|T], In, F),	  % Frequency stored in F
	findall(N, (member(V, F), N is V/Len), Freq). % Normalise F->Freq

% Output the results
writeHdr :-
	format('~t~w~15| - ~t~w\n', ['Benford', 'Measured']).
writeData(Benford, Freq) :-
	format('~t~2f%~15| - ~t~2f%\n', [Benford*100, Freq*100]).

go :- % main goal
	findall(B, (between(1,9,N), benford(N,B)), Benford),
	findall(C, firstchar(C), Fc), freq(Fc, Freq),
	writeHdr, maplist(writeData, Benford, Freq).
