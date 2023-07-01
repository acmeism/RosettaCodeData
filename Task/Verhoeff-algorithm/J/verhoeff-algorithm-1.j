cyc=: | +/~@i.   NB. cyclic group, order y
ac=:  |(+-/~@i.) NB. anticyclic group, order y
a2n=: (+#)@     NB. add 2^n
di=: (cyc,.cyc a2n),((ac a2n),.ac)

D=:   di 5
INV=: ,I.0=D
P=: {&(C.1 5 8 9 4 2 7 0;3 6)^:(i.8) i.10

verhoeff=: {{
  c=. 0
  for_N. |.10 #.inv y do.
    c=. D{~<c,P{~<(8|N_index),N
  end.
}}

traceverhoeff=: {{
  r=. EMPTY
  c=. 0
  for_N. |.10 #.inv y do.
    c0=. c
    c=. D{~<c,p=.P{~<(j=.8|N_index),N
    r=. r, c,p,j,N_index,N,c0
  end.
  labels=. cut 'cᵢ p[i,nᵢ] i nᵢ n cₒ'
  1 1}.}:~.":labels,(<;._1"1~[:*/' '=])' ',.":r
}}

checkdigit=: INV {~ verhoeff@*&10
valid=: 0 = verhoeff
