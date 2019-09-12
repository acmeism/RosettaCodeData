% attribute store is 'Name - Value' pairs with unique names
attrs( H, [N-V | R]) :- !, memberchk( N-X, H), X = V, (R = [], ! ; attrs( H, R)).
attrs( HS, AttrsL) :- maplist( attrs, HS, AttrsL).

in(    HS, Attrs) :- in( member, HS, Attrs).
in( G, HS, Attrs) :- call( G, A, HS), attrs( A, Attrs).

left_of( [A,B], HS) :- append( _, [A,B | _], HS).
next_to( [A,B], HS) :- left_of( [A,B], HS) ; left_of( [B,A], HS).

zebra( Owner, Houses):-
    Houses = [A,_,C,_,_],                                               % 1
    maplist( in(Houses), [ [ nation-englishman,   color-red          ]  % 2
                         , [ nation-swede,        owns -dog          ]  % 3
                         , [ nation-dane,         drink-tea          ]  % 4
                         , [ drink -coffee,       color-green        ]  % 6
                         , [ smoke -'Pall Mall',  owns -birds        ]  % 7
                         , [ color -yellow,       smoke-'Dunhill'    ]  % 8
                         , [ drink -beer,         smoke-'Blue Master']  % 13
                         , [ nation-german,       smoke-'Prince'     ]  % 14
                         ] ),
    in( left_of, Houses,   [[color -green    ],  [color -white    ]]),  % 5
    in( left_of,  [C,A],   [[drink -milk     ],  [nation-norwegian]]),  % 9, 10
    maplist( in( next_to, Houses),
                         [ [[smoke -'Blend'  ],  [owns -cats      ]]    % 11
                         , [[owns  -horse    ],  [smoke-'Dunhill' ]]    % 12
                         , [[nation-norwegian],  [color-blue      ]]    % 15
                         , [[drink -water    ],  [smoke-'Blend'   ]]    % 16
                         ] ),
    in( Houses, [owns-zebra, nation-Owner]).
