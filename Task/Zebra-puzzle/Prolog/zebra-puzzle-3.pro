?- time(( zebra(Z,HS), ( maplist(length,HS,_) -> maplist(sort,HS,S),
          maplist(writeln,S),nation(Z,R),nl,writeln(R) ), false ; true)).

[color(yellow),drink(water), nation(norwegian), owns(cats),  smoke(Dunhill)    ]
[color(blue),  drink(tea),   nation(dane),      owns(horse), smoke(Blend)      ]
[color(red),   drink(milk),  nation(englishman),owns(birds), smoke(Pall Mall)  ]
[color(green), drink(coffee),nation(german),    owns(zebra), smoke(Prince)     ]
[color(white), drink(beer),  nation(swede),     owns(dog),   smoke(Blue Master)]

german
% 138,899 inferences, 0.060 CPU in 0.110 seconds (55% CPU, 2311655 Lips)
true.
