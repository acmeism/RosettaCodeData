zebra( Z, HS):-
    length( HS, 5),
    member( H1,   HS),    nation(H1, eng),       color(H1, red),
    member( H2,   HS),    nation(H2, swe),       owns( H2, dog),
    member( H3,   HS),    nation(H3, dane),      drink(H3, tea),
    left_of(A,B,  HS),    color(  A, green),     color( B, white),
    member( H4,   HS),    drink( H4, coffee),    color(H4, green),
    member( H5,   HS),    smoke( H5, palmal),    owns( H5, birds),
    member( H6,   HS),    color( H6, yellow),    smoke(H6, dunhill),
    middle( C,    HS),    drink(  C, milk),
    first(  D,    HS),    nation( D, norweg),
    next_to(E,F,  HS),    smoke(  E, blend),     owns(  F, cats),
    next_to(G,H,  HS),    owns(   G, horse),     smoke( H, dunhill),
    member( H7,   HS),    smoke( H7, bluemas),   drink(H7, beer),
    member( H8,   HS),    nation(H8, german),    smoke(H8, prince),
    next_to(I,J,  HS),    nation( I, norweg),    color( J, blue),
    next_to(V,W,  HS),    drink(  W, water),     smoke( V, blend),
    member( X,    HS),    owns(   X, zebra),     nation(X, Z).

left_of( A, B, HS):- append( _, [A,B|_], HS).
next_to( A, B, HS):- left_of( A, B, HS) ; left_of( B, A, HS).
middle( A, [_,_,A,_,_]).
first( A, [A|_]).

attr( House, Name-Value):-
    memberchk( Name-X, House),           % unique attribute names
    X = Value.                           % set, validate, or reject
nation(H, V):-  attr( H, nation-V).
owns(  H, V):-  attr( H, owns-V).        % select an attribute
smoke( H, V):-  attr( H, smoke-V).       %    from an extensible record
color( H, V):-  attr( H, color-V).       %    of house attributes
drink( H, V):-  attr( H, drink-V).       %    which *is* a house
