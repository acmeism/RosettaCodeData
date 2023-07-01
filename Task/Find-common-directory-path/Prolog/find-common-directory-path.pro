%! directory_prefix(PATHs,STOP0,PREFIX)

directory_prefix([],_STOP0_,'')
:-
!
.

directory_prefix(PATHs0,STOP0,PREFIX)
:-
prolog:once(longest_prefix(PATHs0,STOP0,LONGEST_PREFIX)) ->
prolog:atom_concat(PREFIX,STOP0,LONGEST_PREFIX) ;
PREFIX=''
.

%! longest_prefix(PATHs,STOP0,PREFIX)

longest_prefix(PATHs0,STOP0,PREFIX)
:-
QUERY=(shortest_prefix(PATHs0,STOP0,SHORTEST_PREFIX)) ,
prolog:findall(SHORTEST_PREFIX,QUERY,SHORTEST_PREFIXs) ,
lists:reverse(SHORTEST_PREFIXs,LONGEST_PREFIXs) ,
lists:member(PREFIX,LONGEST_PREFIXs)
.

%! shortest_prefix(PATHs,STOP0,PREFIX)

shortest_prefix([],_STOP0_,_PREFIX_) .

shortest_prefix([PATH0|PATHs0],STOP0,PREFIX)
:-
starts_with(PATH0,PREFIX) ,
ends_with(PREFIX,STOP0) ,
shortest_prefix(PATHs0,STOP0,PREFIX)
.

%! starts_with(TARGET,START)

starts_with(TARGET,START)
:-
prolog:atom_concat(START,_,TARGET)
.

%! ends_with(TARGET,END)

ends_with(TARGET,END)
:-
prolog:atom_concat(_,END,TARGET)
.
