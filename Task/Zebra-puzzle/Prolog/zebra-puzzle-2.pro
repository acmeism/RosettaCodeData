% register unique attribute names from rules
attrs(H,[N-V|R]):- memberchk( N-X, H), X=V, (R=[] -> true ; attrs(H,R)).

in(HS,Attrs)  :- member(H,HS), attrs(H,Attrs).
in(HS,G,AttrsL):- call(G,Args,HS), maplist(attrs,Args,AttrsL).

left_of([A,B],HS):- append(_,[A,B|_],HS).
next_to([A,B],HS):- left_of([A,B],HS) ; left_of([B,A],HS).

zebra(Owner,Houses):-
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
    in(Houses, left_of,    [[color -green    ],  [color -white    ]]),  % 5
    maplist( attrs, [C,A], [[drink -milk     ],                         % 9
                            [nation-norwegian]]),                       % 10
    maplist( in(Houses, next_to),
                         [ [[smoke -'Blend'  ],  [owns -cats      ]]    % 11
                         , [[owns  -horse    ],  [smoke-'Dunhill' ]]    % 12
                         , [[nation-norwegian],  [color-blue      ]]    % 15
                         , [[drink -water    ],  [smoke-'Blend'   ]]    % 16
                         ] ),
    in(Houses, [owns-zebra, nation-Owner]).
