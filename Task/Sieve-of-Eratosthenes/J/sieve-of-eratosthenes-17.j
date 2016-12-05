sieve=:verb define
  seq=: 2+i.y-1  NB. 2 thru y
  n=. 1
  l=. #seq
  whilst. -.seq-:prev do.
     prev=. seq
     n=. 1+n+1 i.~ * (n-1)}.seq
     inds=. (2*n)+n*i.(<.l%n)-1
     seq=. 0 inds} seq
  end.
  seq -. 0
)
