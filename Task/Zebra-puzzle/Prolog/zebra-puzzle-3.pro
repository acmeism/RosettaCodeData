attrs( R, [N-V|T]):-                     % extensible record, attribute specs
    memberchk( N-X, R),                  % unique attribute names
    X = V,                               % set, validate, or reject
    ( T = [] -> true ; attrs( R, T) ).

specs( P, Hs, [Spec1]) :- call(P, A, Hs), attrs(A, Spec1).
specs( P, Hs, [Spec1, Spec2]) :- call(P, A, B, Hs), attrs(A, Spec1), attrs(B, Spec2).

left_of( A, B, HS):- append( _, [A,B|_], HS).
next_to( A, B, HS):- left_of( A, B, HS) ; left_of( B, A, HS).

zebra( Zebra, Houses):-                  % a house *is* a collection of attributes
    Houses = [A,_,C,_,_],                                                     % 1
    maplist( specs( member, Houses),
                             [ [[ nation-englishman,   color-red          ]]  % 2
                             , [[ nation-swede,        owns -dog          ]]  % 3
                             , [[ nation-dane,         drink-tea          ]]  % 4
                             , [[ drink -coffee,       color-green        ]]  % 6
                             , [[ smoke -'Pall Mall',  owns -birds        ]]  % 7
                             , [[ color -yellow,       smoke-'Dunhill'    ]]  % 8
                             , [[ drink -beer,         smoke-'Blue Master']]  % 13
                             , [[ nation-german,       smoke-'Prince'     ]]  % 14
                             ] ),
    specs( left_of, Houses,    [[color -green    ],  [color-white     ]]),    % 5
    maplist( attrs, [A, C],    [[nation-norwegian],  [drink-milk      ]]),    % 10, 9
    maplist( specs( next_to, Houses),
                             [ [[smoke -'Blend'  ],  [owns -cats      ]]      % 11
                             , [[owns  -horse    ],  [smoke-'Dunhill' ]]      % 12
                             , [[nation-norwegian],  [color-blue      ]]      % 15
                             , [[drink -water    ],  [smoke-'Blend'   ]]      % 16
                             ] ),
    specs( member, Houses,     [[ owns-zebra, nation-Zebra]]).
