% populate domain by selecting from it
attrs(H,[N-V|R]):- memberchk( N-X, H), X=V,  % unique attribute names
                   (R=[] -> true ; attrs(H,R)).
one_of(HS,AS)  :- member(H,HS), attrs(H,AS).
two_of(HS,G,AS):- call(G,H1,H2,HS), maplist(attrs,[H1,H2],AS).
left_of(A,B,HS):- append(_,[A,B|_],HS).
next_to(A,B,HS):- left_of(A,B,HS) ; left_of(B,A,HS).

zebra(Zebra,Houses):-
    Houses = [A,_,C,_,_],                                                   % 1
    maplist( one_of(Houses), [ [ nation-englishman,   color-red          ]  % 2
                             , [ nation-swede,        owns -dog          ]  % 3
                             , [ nation-dane,         drink-tea          ]  % 4
                             , [ drink -coffee,       color-green        ]  % 6
                             , [ smoke -'Pall Mall',  owns -birds        ]  % 7
                             , [ color -yellow,       smoke-'Dunhill'    ]  % 8
                             , [ drink -beer,         smoke-'Blue Master']  % 13
                             , [ nation-german,       smoke-'Prince'     ]  % 14
                             ] ),
    two_of(Houses, left_of,    [[color -green    ],  [color -white    ]]),  % 5
    maplist(attrs, [C,A],      [[drink -milk     ],  [nation-norwegian]]),  % 9, 10
    maplist(two_of(Houses,next_to),
                             [ [[smoke -'Blend'  ],  [owns -cats      ]]    % 11
                             , [[owns  -horse    ],  [smoke-'Dunhill' ]]    % 12
                             , [[nation-norwegian],  [color-blue      ]]    % 15
                             , [[drink -water    ],  [smoke-'Blend'   ]]    % 16
                             ] ),
    one_of(Houses, [ owns-zebra, nation-Zebra]).
