pytr=: 3 :0
  r=. i. 0 3
  for_a. 1 + i. <.(y-1)%3 do.
    b=. 1 + a + i. <.(y%2)-3*a%2
    c=. a +&.*: b
    keep=. (c = <.c) *. y >: a+b+c
    if. 1 e. keep do.
      r=. r, a,.b ,.&(keep&#) c
    end.
  end.
  (,.~ prim"1)r
)

prim=: 1 = 2 +./@{. |:
