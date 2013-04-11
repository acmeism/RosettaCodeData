NextPermutation := function(a)
   local i, j, k, n, t;
   n := Length(a);
   i := n - 1;
   while i > 0 and a[i] > a[i + 1] do
      i := i - 1;
   od;
   j := i + 1;
   k := n;
   while j < k do
      t := a[j];
      a[j] := a[k];
      a[k] := t;
      j := j + 1;
      k := k - 1;
   od;
   if i = 0 then
      return false;
   else
      j := i + 1;
      while a[j] < a[i] do
         j := j + 1;
      od;
      t := a[i];
      a[i] := a[j];
      a[j] := t;
      return true;
   fi;
end;

Permutations := function(n)
   local a, L;
   a := List([1 .. n], x -> x);
   L := [ ];
   repeat
      Add(L, ShallowCopy(a));
   until not NextPermutation(a);
   return L;
end;

Permutations(3);
[ [ 1, 2, 3 ], [ 1, 3, 2 ],
  [ 2, 1, 3 ], [ 2, 3, 1 ],
  [ 3, 1, 2 ], [ 3, 2, 1 ] ]
