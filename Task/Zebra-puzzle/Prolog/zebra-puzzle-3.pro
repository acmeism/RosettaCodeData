?- time(( zebra(Z,HS), ( maplist(length,HS,_) -> maplist(sort,HS,S),
          maplist(writeln,S),nl,writeln(Z) ), false ; true)).

[color-yellow,drink-water, nation-norwegian, owns-cats,  smoke-Dunhill    ]
[color-blue,  drink-tea,   nation-dane,      owns-horse, smoke-Blend      ]
[color-red,   drink-milk,  nation-englishman,owns-birds, smoke-Pall Mall  ]
[color-green, drink-coffee,nation-german,    owns-zebra, smoke-Prince     ]
[color-white, drink-beer,  nation-swede,     owns-dog,   smoke-Blue Master]

german
% 234,852 inferences, 0.100 CPU in 0.170 seconds (59% CPU, 2345143 Lips)
true.
