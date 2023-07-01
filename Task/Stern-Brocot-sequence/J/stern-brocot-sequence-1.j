sternbrocot=:1 :0
  ind=. 0
  seq=. 1 1
  while. -. u seq do.
    ind=. ind+1
    seq=. seq, +/\. seq {~ _1 0 +ind
  end.
)
