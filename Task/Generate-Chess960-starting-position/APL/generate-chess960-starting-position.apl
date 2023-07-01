⍝ Utility functions
divmod ← {(⌊⍺÷⍵),⍵|⍺}
indices ← {(⍺∊⍵)/⍳⍴⍺}
∇result ← place placement; array; index; piece; result
  (array piece index) ← placement
  array[(array indices '-')[index]] ← piece
  result ← array
∇
∇result ← chess960 spid; array; n; b1; b2; n1; n2; q
  spid ← 960 | spid
  array ← 8/'-'
  (n b1) ← spid divmod 4
  array[2+2×b1] ← 'B'
  (n b2) ← n divmod 4
  array[1+2×b2] ← 'B'
  (n q) ← n divmod 6
  array ← place array 'Q' (1+q)
  n1 ← 1⍳⍨n<4 7 9 10
  array ← place array 'N' n1
  n2 ← (1 2 3 4 2 3 4 3 4 4)[n+1]
  array ← place array 'N' n2
  array ← place array 'R' 1
  array ← place array 'K' 1
  array ← place array 'R' 1
  result ← spid, array
∇
