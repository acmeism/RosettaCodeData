% populate domain by selecting from it
nation(H,V):-  memberchk( nation(X), H), X=V.  % select the "nation" attribute
owns(  H,V):-  memberchk( owns(  X), H), X=V.  % ...
smoke( H,V):-  memberchk( smoke( X), H), X=V.
color( H,V):-  memberchk( color( X), H), X=V.
drink( H,V):-  memberchk( drink( X), H), X=V.

to_the_left(A,B,HS):- append(_,[A,B|_],HS).
next_to(A,B,HS):- to_the_left(A,B,HS) ; to_the_left(B,A,HS).
middle(A, [_,_,A,_,_]).
first(A, [A|_]).

zebra(Zebra,Houses):-
    length(Houses,5),
    member(H2, Houses),   nation(H2, englishman),   color( H2, red),
    member(H3, Houses),   nation(H3, swede),        owns(  H3, dog),
    member(H4, Houses),   nation(H4, dane),         drink( H4, tea),
    to_the_left(H5,H5b,Houses), color(H5, green),   color(H5b, white),
    member(H6, Houses),   drink( H6, coffee),       color( H6, green),
    member(H7, Houses),   smoke( H7, 'Pall Mall'),  owns(  H7, birds),
    member(H8, Houses),   color( H8, yellow),       smoke( H8, 'Dunhill'),
    middle(H9, Houses),   drink( H9, milk),
    first(H10, Houses),  nation(H10, norwegian),
    next_to(H11,H11b,Houses),  smoke( H11, 'Blend'),   owns( H11b, cats),
    next_to(H12,H12b,Houses),  owns(  H12, horse),     smoke(H12b, 'Dunhill'),
    member(H13, Houses),       drink( H13, beer),      smoke( H13, 'Blue Master'),
    member(H14, Houses),       nation(H14, german),    smoke( H14, 'Prince'),
    next_to(H15,H15b,Houses),  nation(H15, norwegian), color(H15b, blue),
    next_to(H16,H16b,Houses),  drink( H16, water),     smoke(H16b, 'Blend'),
    member(Zebra,Houses),      owns(Zebra, zebra).
