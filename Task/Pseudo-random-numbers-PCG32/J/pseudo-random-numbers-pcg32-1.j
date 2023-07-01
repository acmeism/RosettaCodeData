PCG32GEN=: {{
  g=. cocreate''
  'state0__g seq__g'=. m
  init__g=: {{
    max=: 2^64x
    u64=: &.((64#2x)&#:) NB. binary domain operation
    U64=: max&|          NB. integer domain result
    U32=: (2^32)&(<.@|)
    and=: *. u64
    xor=: ~: u64
     or=:  +. u64
    lsl=: max <.@| ] * 2x^[
      N=: 6364136223846793005x
    inc=: U64 1 2x p. seq
  state=: U64 inc+N*inc+state0
  }}
  next__g=: g {{ m[y
    xs=. U32 _27 lsl state xor _18 lsl state
    rot=. -_59 lsl state
    state=: U64 inc+N*state
    U32 (rot lsl xs) or (31 and rot) lsl xs
  }}
  init__g''
  (;'next_';(;g);'_')~
}}

next_float=: %&(2^32)
