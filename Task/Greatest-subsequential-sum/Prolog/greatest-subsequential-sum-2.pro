subseq(Sub, Seq) :- suffix(X, Seq), prefix(Sub, X).

maxsubseq(List, Sub, Sum) :-
  findall(X, subseq(X, List), Subs),
  maplist(sum_list, Subs, Sums),
  max_list(Sums, Sum),
  nth(N, Sums, Sum),
  nth(N, Subs, Sub).
