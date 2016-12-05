?- time(( zebra(Z,HS), ( maplist(length,HS,_) -> maplist(sort,HS,S),
          maplist(writeln,S), nl, writeln(Z) ), false ; true)).

[color-yellow,drink-water, nation-norwegian, owns-cats,  smoke-Dunhill    ]
[color-blue,  drink-tea,   nation-dane,      owns-horse, smoke-Blend      ]
[color-red,   drink-milk,  nation-englishman,owns-birds, smoke-Pall Mall  ]
[color-green, drink-coffee,nation-german,    owns-zebra, smoke-Prince     ]
[color-white, drink-beer,  nation-swede,     owns-dog,   smoke-Blue Master]

german
% 202,730 inferences, 0.031 CPU in 0.031 seconds (100% CPU, 6497715 Lips)
true.
