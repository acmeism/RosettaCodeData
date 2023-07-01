|a b c|

a := #('a' 'b' 'c').
b := #('A' 'B' 'C').
c := #(1 2 3).
1 to: (a size) do: [ :i |
  ((a at: i),(b at: i),(c at: i)) displayNl.
].
