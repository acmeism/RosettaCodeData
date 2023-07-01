pali(Str) :- sub_string(Str, 0, 1, _, X), string_concat(Str2, X, Str), string_concat(X, Mid, Str2), pali(Mid).
pali(Str) :- string_length(Str, Len), Len < 2.
