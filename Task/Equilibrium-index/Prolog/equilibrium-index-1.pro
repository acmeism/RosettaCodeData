equilibrium_index(List, Index) :-
    append(Front, [_|Back], List),
    sumlist(Front, Sum),
    sumlist(Back,  Sum),
    length(Front, Len),
    Index is Len.
