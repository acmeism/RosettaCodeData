pali(Str) :- sub_atom(Str, 0, 1, _, X), atom_concat(Str2, X, Str), atom_concat(X, Mid, Str2), pali(Mid).
pali(Str) :- atom_length(Str, Len), Len < 2.
