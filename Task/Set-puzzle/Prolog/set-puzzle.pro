do_it(N) :-	
	card_sets(N, Cards, Sets),
	!,
	format('Cards: ~n'),
	maplist(print_card, Cards),
	format('~nSets: ~n'),
	maplist(print_set, Sets).
	
print_card(Card) :- format('  ~p ~p ~p ~p~n', Card).
print_set(Set) :- maplist(print_card, Set), nl.

n(9,4).
n(12,6).

card_sets(N, Cards, Sets) :-
	n(N,L),
	repeat,
	random_deal(N, Cards),	
	setof(Set, is_card_set(Cards, Set), Sets),	
	length(Sets, L).

random_card([C,S,N,Sh]) :-
	random_member(C, [red, green, purple]),
	random_member(S, [oval, squiggle, diamond]),
	random_member(N, [one, two, three]),
	random_member(Sh, [solid, open, striped]).
	
random_deal(N, Cards) :-
	length(Cards, N),
	maplist(random_card, Cards).
	
is_card_set(Cards, Result) :-
	select(C1, Cards, Rest),
	select(C2, Rest, Rest2),
	select(C3, Rest2, _),
	
	match(C1, C2, C3),
	sort([C1,C2,C3], Result).
	
match([],[],[]).
match([A|T1],[A|T2],[A|T3]) :-
	match(T1,T2,T3).
match([A|T1],[B|T2],[C|T3]) :-
	dif(A,B), dif(B,C), dif(A,C),
	match(T1,T2,T3).
