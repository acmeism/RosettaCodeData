map_name1(C, Cs, C, Cs).
map_name1(C, Cs, Fc, [Fc,C|Cs]) :- member(C, ['a','e','i','o','u']).
map_name1(C, Cs, Fc, [Fc|Cs]) :-
    \+ member(C, ['a','e','i','o','u']),
    dif(C, Fc).

map_name(C, Cs, Fc, Name) :-
    map_name1(C, Cs, Fc, NChars),
    atom_chars(Name, NChars).

song(Name) :-
   string_lower(Name, LName),
   atom_chars(LName, [First|Chars]),

   map_name(First, Chars, 'b', BName),
   map_name(First, Chars, 'f', FName),
   map_name(First, Chars, 'm', MName),

   maplist(write,
           [Name, ", ", Name, ", bo-", BName, '\n',
            "Banana-fana fo-", FName, '\n',
            "Fee-fi-mo-", MName, '\n',
            Name, "!\n\n"]).

test :-
    maplist(song, ["Gary", "Earl", "Billy", "Felix", "Mary"]).
