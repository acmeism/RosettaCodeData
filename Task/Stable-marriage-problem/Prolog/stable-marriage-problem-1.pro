%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rules

stable_mariage :-
	new(LstMan, chain),
	forall(man(X),
	       (   prefere(X, Lst),
		   new(P, man(X, Lst)),
		   send(LstMan, append, P))),

	new(LstWoman, chain),
	forall(woman(X),
	       (   prefere(X, Lst),
		   new(P, woman(X, Lst)),
		   send(LstWoman, append, P))),
	send(LstMan, for_all, message(@arg1, init_liste, LstWoman)),
	send(LstWoman, for_all, message(@arg1, init_liste, LstMan)),

	round(LstMan, LstWoman),
	new(LstCouple, chain),
	% creation of the couple.
	send(LstWoman, for_all, and(message(@prolog, create_couple, @arg1, LstCouple),
				   message(@pce, write_ln, @arg1?name, with, @arg1?elu?name))),

	nl,
	
	% test of the stability of couples
	stability(LstCouple),
	nl,

	% Perturbation of couples
	get(LstCouple, size, Len),
	get_two_random_couples(Len, V1, V2),

	get(LstCouple, nth0, V1, C1),
	get(LstCouple, nth0, V2, C2),
	new(NC1, tuple(C1?first, C2?second)),
	new(NC2, tuple(C2?first, C1?second)),
	send(LstCouple, nth0, V1, NC1),
	send(LstCouple, nth0, V2, NC2),

	send(@pce, write_ln, 'perturbation of couples'),
	send(@pce, write_ln, NC1?second, with, NC1?first),
	send(@pce, write_ln, NC2?second, with, NC2?first),
	nl,
	
	stability(LstCouple).

get_two_random_couples(Len, C1, C2) :-
	C1 is random(Len),
	repeat,
	C2 is random(Len),
	C1 \= C2.

create_couple(Woman, LstCouple ) :-
	send(LstCouple, append, new(_, tuple(Woman?elu?name, Woman?name))).

% iterations of the algorithm
round(LstMan, LstWoman) :-
	send(LstMan, for_some, message(@arg1, propose)),
	send(LstWoman, for_some, message(@arg1, dispose)),
	(   \+send(LstWoman, for_all, @arg1?status == maybe)
	->
	    round(LstMan, LstWoman)
	;
	    true
	).

:-pce_begin_class(person, object, "description of a person").
variable(name, object, both, "name of the person").
variable(preference, chain, both, "list of priority").
variable(status, object, both, "statut of engagement : maybe / free").

initialise(P, Name, Pref) :->
	send(P, send_super, initialise),
	send(P, slot, name, Name),
	send(P, slot, preference, Pref),
	send(P, slot, status, free).

% reception of the list of partners
init_liste(P, Lst) :->
	% we replace the list of name of partners
	% with the list of persons partners.
	new(NLP, chain),
	get(P, slot, preference, LP),
	send(LP, for_all, message(@prolog, find_person,@arg1, Lst, NLP)),
	send(P, slot, preference, NLP).

:- pce_end_class(person).



find_person(Name, LstPerson, LstPref) :-
	get(LstPerson, find, @arg1?name == Name, Elem),
	send(LstPref, append, Elem).

:-pce_begin_class(man, person, "description of a man").

initialise(P, Name, Pref) :->
	send(P, send_super, initialise, Name, Pref).

% a man propose "la botte" to a woman
propose(P) :->
	get(P, slot, status, free),
	get(P, slot, preference, XPref),
	get(XPref, delete_head, Pref),
	send(P, slot, preference, XPref),
	send(Pref, proposition, P).

refuse(P) :->
	send(P, slot, status, free).

accept(P) :->
	send(P, slot, status, maybe).

:- pce_end_class(man).

:-pce_begin_class(woman, person, "description of a woman").
variable(elu, object, both, "name of the elu").
variable(contact, chain, both, "men that have contact this woman").

initialise(P, Name, Pref) :->
	send(P, send_super, initialise, Name, Pref),
	send(P, slot, contact, new(_, chain)),
	send(P, slot, elu, @nil).

% a woman decide Maybe/No
dispose(P) :->
	get(P, slot, contact, Contact),
	get(P, slot, elu, Elu),

	(   Elu \= @nil
	->
	    send(Contact, append, Elu)
	;
	    true),

	new(R, chain),
	send(Contact, for_all, message(P, fetch, @arg1, R)),
	send(R, sort, ?(@arg1?first, compare, @arg2?first)),
	get(R, delete_head, Tete),
	send(Tete?second, accept),
	send(P, slot, status, maybe),
	send(P, slot, elu, Tete?second),
	send(R, for_some, message(@arg1?second, refuse)),
	send(P, slot, contact, new(_, chain)) .


% looking for the person of the given name  Contact
% Adding it in the chain Chain
fetch(P, Contact, Chain) :->
	get(P, slot, preference, Lst),
	get(Lst, find, @arg1?name == Contact?name, Elem),
	get(Lst, index, Elem, Ind),
	send(Chain, append, new(_, tuple(Ind, Contact))).

% a woman receive a proposition from a man
proposition(P, Name) :->
	get(P, slot, contact, C),
	send(C, append, Name),
	send(P, slot, contact, C).

:- pce_end_class(woman).

% computation of the stability od couple
stability(LstCouple) :-
	chain_list(LstCouple, LstPceCouple),
	maplist(transform, LstPceCouple, PrologLstCouple),
	study_couples(PrologLstCouple, [], UnstableCouple),
	(   UnstableCouple = []
	->
	    writeln('Couples are stable')
	;
	    sort(UnstableCouple, SortUnstableCouple),
	    writeln('Unstable couples are'),
	    maplist(print_unstable_couple, SortUnstableCouple),
	    nl
	).


print_unstable_couple((C1, C2)) :-
	format('~w and ~w~n', [C1, C2]).

transform(PceCouple, couple(First, Second)):-
	get(PceCouple?first, value, First),
	get(PceCouple?second, value, Second).

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
