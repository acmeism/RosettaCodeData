rowSums=: 3 :0"0
  z=. (y+1){. 1x
  for_ks. <\1+i.y do.
    n=.{: k=.>ks
    r=.#c=. ({.~* i._1:)(n,0.5 _1.5) p. k
    s=.#d=.({.~* i._1:)c-r{.k
    'v i'=.|: \:~(c,d),. r ,&({.&k) s
    a=. +/(n{z),(_1^1x+2|i) * v{z
    z=. a n}z
  end.
)
