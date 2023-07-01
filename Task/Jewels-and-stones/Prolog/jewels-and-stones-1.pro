:- system:set_prolog_flag(double_quotes,codes) .

count_jewels(STONEs0,JEWELs0,COUNT)
:-
findall(X,(member(X,JEWELs0),member(X,STONEs0)),ALLs) ,
length(ALLs,COUNT)
.
