|a b c|

a := #('a' 'b' 'c').
b := #('A' 'B' 'C').
c := #(1 2 3).
a with:b with:c do:[:ai :bi :ci |
  (ai,bi,ci) displayNl.
].
