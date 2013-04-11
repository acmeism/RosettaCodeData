insert_sort(L1,L2) :-
  insert_sort_intern(L1,[],L2).

insert_sort_intern([],L,L).
insert_sort_intern([H|T],L1,L) :-
  insert(L1,H,L2),
  insert_sort_intern(T,L2,L).

insert([],X,[X]).
insert([H|T],X,[X,H|T]) :-
  X =< H,
  !.
insert([H|T],X,[H|T2]) :-
  insert(T,X,T2).
