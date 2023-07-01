isqrt_float=: <.@:%:
isqrt_newton=: 9&$: :(x:@:<.@:-:@:(] + x:@:<.@:%)^:_&>~&:x:)


align=: (|.~ i.&' ')"1
comma=: (' ' -.~ [: }: [: , [: (|.) _3 (',' ,~ |.)\ |.)@":&>
While=: {{ u^:(0-.@:-:v)^:_ }}

isqrt=: 3 :0&>
 y =. x: y
 NB. q is a power of 4 that's greater than y.  Append 0 0 under binary representation
 q =. y (,&0 0x&.:#:@:])While>: 1x
 z =. y               NB. set  z  to the value of y.
 r =. 0x              NB. initialize  r  to zero.
 while. 1 < q do.     NB. perform while  q > unity.
  q =. _2&}.&.:#: q   NB. integer divide by 4 (-2 drop under binary representation)
  t =. (z - r) - q    NB. compute value of  t.
  r =. }:&.:#: r      NB. integer divide by  two. (curtail under binary representation)
  if. 0 <: t do.
   z =. t             NB. set  z  to value of t
   r =. r + q         NB. compute new value of r
  end.
 end.
 NB. r  is now the  isqrt(y). (most recent value computed)
 NB. Sidenote: Also, Z is now the remainder after square root
 NB. ie. r^2 + z = y, so if z = 0 then x is a perfect square
 NB. r , z
)
