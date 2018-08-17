:- use_module(library(clpfd)).

zebra :-
    Nation = [Englishman, Spaniard, Japanese,     Ukrainian,   Norwegian ],
    Color  = [Red,        Green,    White,        Yellow,      Blue      ],
    Smoke  = [Oldgold,    Kools,    Chesterfield, Luckystrike, Parliament],
    Pet    = [Dog,        Snails,   Fox,          Horse,       Zebra     ],
    Drink  = [Tea,        Coffee,   Milk,         Orangejuice, Water     ],

    % house numbers 1 to 5
    Nation ins 1..5,
    Color  ins 1..5,
    Smoke  ins 1..5,
    Pet    ins 1..5,
    Drink  ins 1..5,

    % the values in each list are exclusive
    all_different(Nation),
    all_different(Color),
    all_different(Smoke),
    all_different(Pet),
    all_different(Drink),

    % actual constraints
    Englishman    #= Red,
    Spaniard      #= Dog,
    Green         #= Coffee,
    Ukrainian     #= Tea,
    Green         #= White + 1,
    Oldgold       #= Snails,
    Yellow        #= Kools,
    Milk          #= 3,
    Norwegian     #= 1,
    (Chesterfield #= Fox   - 1 #\/ Chesterfield #= Fox   + 1),
    (Kools        #= Horse - 1 #\/ Kools        #= Horse + 1),
    Luckystrike   #= Orangejuice,
    Japanese      #= Parliament,
    (Norwegian    #= Blue  - 1 #\/ Norwegian    #= Blue  + 1),

    % get solution
    flatten([Nation, Color, Smoke, Pet, Drink], List), label(List),

    % print the answers
    sort([Englishman-englishman, Spaniard-spaniard, Japanese-japanese,         Ukrainian-ukrainian,     Norwegian-norwegian],   NationNames),
    sort([Red-red,               Green-green,       White-white,               Yellow-yellow,           Blue-bule],             ColorNames),
    sort([Oldgold-oldgold,       Kools-kools,       Chesterfield-chesterfield, Luckystrike-luckystrike, Parliament-parliament], SmokeNames),
    sort([Dog-dog,               Snails-snails,     Fox-fox,                   Horse-horse,             Zebra-zebra],           PetNames),
    sort([Tea-tea,               Coffee-coffee,     Milk-milk,                 Orangejuice-orangejuice, Water-water],           DrinkNames),
    Fmt = '~w~16|~w~32|~w~48|~w~64|~w~n',
    format(Fmt, NationNames),
    format(Fmt, ColorNames),
    format(Fmt, SmokeNames),
    format(Fmt, PetNames),
    format(Fmt, DrinkNames).
