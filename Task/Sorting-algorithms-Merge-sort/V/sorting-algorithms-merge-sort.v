[merge
   [mergei
       uncons [swap [>] split] dip
       [[*m] e2 [*a1] b1 a2 : [*m *a1 e2] b1 a2] view].

   [a b : [] a b] view
   [size zero?] [pop concat]
       [mergei]
   tailrec].

[msort
  [splitat [arr a : [arr a take arr a drop]] view i].
  [splitarr dup size 2 / >int splitat].

  [small?] []
    [splitarr]
    [merge]
  binrec].
