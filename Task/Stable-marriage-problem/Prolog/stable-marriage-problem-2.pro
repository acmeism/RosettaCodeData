:- dynamic person/4, prop/2.
% person(Name, Preference, Status, Candidate)
% prop(Name, List_of_Candidates) (for a woman)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% facts
prefere(abe,[ abi, eve, cath, ivy, jan, dee, fay, bea, hope, gay]).
prefere(  bob,[ cath, hope, abi, dee, eve, fay, bea, jan, ivy, gay]).
prefere(  col,[ hope, eve, abi, dee, bea, fay, ivy, gay, cath, jan]).
prefere(  dan,[ ivy, fay, dee, gay, hope, eve, jan, bea, cath, abi]).
prefere(   ed,[ jan, dee, bea, cath, fay, eve, abi, ivy, hope, gay]).
prefere( fred,[ bea, abi, dee, gay, eve, ivy, cath, jan, hope, fay]).
prefere(  gav,[ gay, eve, ivy, bea, cath, abi, dee, hope, jan, fay]).
prefere(  hal,[ abi, eve, hope, fay, ivy, cath, jan, bea, gay, dee]).
prefere(  ian,[ hope, cath, dee, gay, bea, abi, fay, ivy, jan, eve]).
prefere(  jon,[ abi, fay, jan, gay, eve, bea, dee, cath, ivy, hope]).

prefere(  abi,[ bob, fred, jon, gav, ian, abe, dan, ed, col, hal]).
prefere(  bea,[ bob, abe, col, fred, gav, dan, ian, ed, jon, hal]).
prefere( cath,[ fred, bob, ed, gav, hal, col, ian, abe, dan, jon]).
prefere(  dee,[ fred, jon, col, abe, ian, hal, gav, dan, bob, ed]).
prefere(  eve,[ jon, hal, fred, dan, abe, gav, col, ed, ian, bob]).
prefere(  fay,[ bob, abe, ed, ian, jon, dan, fred, gav, col, hal]).
prefere(  gay,[ jon, gav, hal, fred, bob, abe, col, ed, dan, ian]).
prefere( hope,[ gav, jon, bob, abe, ian, dan, hal, ed, col, fred]).
prefere(  ivy,[ ian, col, hal, gav, fred, bob, abe, ed, jon, dan]).
prefere(  jan,[ ed, hal, gav, abe, bob, jon, col, ian, fred, dan]).


man(abe).
man(bob).
man(col).
man(dan).
man(ed).
man(fred).
man(gav).
man(hal).
man(ian).
man(jon).

woman(abi).
woman(bea).
woman(cath).
woman(dee).
woman(eve).
woman(fay).
woman(gay).
woman(hope).
woman(ivy).
woman(jan).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rules
stable_mariage :-
	%initialization
	retractall(person(_,_,_,_)),
	retractall(prop(_,_)),
	forall(prefere(P, Pref), assert(person(P, Pref, free, none))),
	bagof(X, man(X), LstMen),
	bagof(Y, woman(Y), LstWomen),
	forall(member(Z, LstWomen), assert(prop(Z, []))),

	% compute the mariages
	iteration(LstMen, LstWomen, LstCouple),
	maplist(print_couple,LstCouple),
	nl,

	% test of the stability of couples
	stability(LstCouple),
	nl,

	% Perturbation of couples
	length(LstCouple, Len),
	get_two_random_couples(Len, V1, V2),

	nth0(V1, LstCouple, C1),
	select(C1, LstCouple, Lst1),
	(   V2 > 0 -> V22 is V2 - 1; V22 = V2),
	nth0(V22, Lst1, C2),
	select(C2, Lst1, Lst2),
	C1 = couple(M1, W1),
	C2 = couple(M2, W2),

	writeln('perturbation of couples'),
	format('~w with ~w~n', [W1, M2]),
	format('~w with ~w~n', [W2, M1]),
	nl,
	stability([couple(M1, W2), couple(M2, W1)| Lst2]).


% the algorithm
iteration(Men, Women, LstCouples) :-
	% Men propose
	bagof(M,  X^Y^(member(M, Men),person(M, X, free, Y)), LM),
	forall(member(X, LM),
	       (   retract(person(X, [W|Pref], free, Elu)),
		   assert(person(X, Pref, free, Elu)),
		   retract(prop(W, Prop)),
		   assert(prop(W, [X| Prop])))),
	
	% women dispose
	bagof(W, L^(prop(W, L), L \= []), LW),
	forall(member(W, LW),
	       (   retract(prop(W, Prop)),
	           retract(person(W, Pref, _, Elu)),
		   (   Elu = none -> Prop1 = Prop; Prop1 = [Elu|Prop]),
	           order_prop(Pref, Prop1, [M | Prop2]),
		   retract(person(M, PrefM, _, _)),
		   assert(person(M, PrefM, maybe, W)),
		   forall(member(Y, Prop2),
			  (   retract(person(Y, Pref1, _, _TE)),
			      assert(person(Y, Pref1, free, none)))),
		   assert(prop(W, [])),
		   assert(person(W, Pref, maybe, M))
	       )),
	
	% finished ?
	(   bagof(X, T^Z^(member(X, Women), person(X, T, free, Z)), _LW1) ->
	    iteration(Men, Women, LstCouples)
	;
	    make_couple(Women, LstCouples)
	).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute order preference of candidates.
order_prop(Pref, Prop, Res) :-
	maplist(index(Pref), Prop, Rtemp),
	sort(Rtemp, Rtemp1),
	maplist(simplifie,Rtemp1, Res).

index(Lst, Value, [Ind, Value]) :-
	nth0(Ind, Lst, Value).

simplifie([_, V], V).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
print_couple(couple(M, W)) :-
	format('~w with ~w~n', [W, M]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% creation of couples
make_couple([], []).

make_couple([W | LW], [couple(M, W) | LC]) :-
	make_couple(LW, LC),
	person(W, _, _, M).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% miscellaneous
get_two_random_couples(Len, C1, C2) :-
	C1 is random(Len),
	repeat,
	C2 is random(Len),
	C1 \= C2.

print_unstable_couple((C1, C2)) :-
	format('~w and ~w~n', [C1, C2]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% test the stability of couples
stability(LstCouple) :-
	study_couples(LstCouple, [], CoupleInstable),
	(   CoupleInstable = []
	->
	    writeln('Couples are stable')
	;
	    sort(CoupleInstable, SortCoupleInstable),
	    writeln('Unstable couples are'),
	    maplist(print_unstable_couple, SortCoupleInstable),
	    nl
	).


% compute the stability od couple
study_couples([], UnstableCouple, UnstableCouple).

study_couples([H | T], CurrentUnstableCouple, UnstableCouple):-
	include(unstable_couple(H), T, Lst),
	(   Lst \= []
	->
	    maplist(build_one_couple(H), Lst, Lst1),
	   append(CurrentUnstableCouple, Lst1,CurrentUnstableCouple1)
	;
	   CurrentUnstableCouple1 = CurrentUnstableCouple
	),
	study_couples(T, CurrentUnstableCouple1, UnstableCouple).


build_one_couple(C1, C2, (C1, C2)).

unstable_couple(couple(X1, Y1), couple(X2, Y2)) :-
	prefere(X1, PX1),
	prefere(X2, PX2),
	prefere(Y1, PY1),
	prefere(Y2, PY2),

	% index of women for X1
	nth0(IY12, PX1, Y2),
	nth0(IY11, PX1, Y1),
	% index of men for Y2
	nth0(IX21, PY2, X1),
	nth0(IX22, PY2, X2),

	% index of women for X2
	nth0(IY21, PX2, Y1),
	nth0(IY22, PX2, Y2),
	% index of men for Y1
	nth0(IX11, PY1, X1),
	nth0(IX12, PY1, X2),

	% A couple is unstable
	( (IY12 < IY11 , IX21 < IX22);
	  (IY21 < IY22 , IX12 < IX11)).
