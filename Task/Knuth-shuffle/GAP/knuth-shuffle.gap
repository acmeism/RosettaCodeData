# Return the list L after applying Knuth shuffle.
Shuffle := function(L)
  local i, j, n;
  n := Length(L);
  for i in [n, n-1 .. 1] do
    j := Random(1, i);
    x := L[i];
    L[i] := L[j];
    L[j] := x;
  od;
  return L;
end;

# Return a ''Permutation'' object (a permutation of 1..n).
# They are printed in gap, in cycle decomposition form.
PermShuffle := n -> PermListList([1 .. n], Shuffle([1 .. n]));

Shuffle([1..10]);
# [ 4, 7, 1, 5, 8, 2, 6, 9, 10, 3 ]
PermShuffle(10);
# (1,9)(2,3,6,4,5,10,8,7)

# One may also call the built-in random generator on the symmetric group :
Random(SymmetricGroup(10));
(1,8,2,5,9,6)(3,4,10,7)
