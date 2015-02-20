rosetta_menu([], "") :- !.              %% Incase of an empty list.
rosetta_menu(Items, SelectedItem) :-
    repeat,                             %% Repeat until everything that follows is true.
        display_menu(Items),            %% IO
        get_choice(Choice),             %% IO
    number(Choice),                     %% True if Choice is a number.
    nth1(Choice, Items, SelectedItem),  %% True if SelectedItem is the 1-based nth member of Items, (fails if Choice is out of range)
    !.

display_menu(Items) :-
    nl,
    foreach( nth1(Index, Items, Item),
             format('~w) ~s~n', [Index, Item]) ).

get_choice(Choice) :-
    prompt1('Select a menu item by number:'),
    read(Choice).
