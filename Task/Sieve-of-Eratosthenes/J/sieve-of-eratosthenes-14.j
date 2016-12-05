sieve=:verb define
  seq=: 2+i.y-1  NB. 2 thru y
  n=. 2
  l=. #seq
  whilst. -.seq-:prev do.
     prev=. seq
     mask=. l{.1-(0{.~n-1),1}.l$n{.1
     seq=. seq * mask
     n=. {.((n-1)}.seq)-.0
  end.
  seq -. 0
)
