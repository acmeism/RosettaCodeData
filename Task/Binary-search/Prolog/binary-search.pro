bin_search(Elt,List,Result):-
  length(List,N), bin_search_inner(Elt,List,1,N,Result).

bin_search_inner(Elt,List,J,J,J):-
  nth(J,List,Elt).
bin_search_inner(Elt,List,Begin,End,Mid):-
  Begin < End,
  Mid is (Begin+End) div 2,
  nth(Mid,List,Elt).
bin_search_inner(Elt,List,Begin,End,Result):-
  Begin < End,
  Mid is (Begin+End) div 2,
  nth(Mid,List,MidElt),
  MidElt < Elt,
  NewBegin is Mid+1,
  bin_search_inner(Elt,List,NewBegin,End,Result).
bin_search_inner(Elt,List,Begin,End,Result):-
  Begin < End,
  Mid is (Begin+End) div 2,
  nth(Mid,List,MidElt),
  MidElt > Elt,
  NewEnd is Mid-1,
  bin_search_inner(Elt,List,Begin,NewEnd,Result).
