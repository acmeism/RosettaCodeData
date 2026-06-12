invseq=: {{
  cnt=. 0, seq=. i. nxt=. 0
  while. -. u seq do.
    k=. nxt{cnt
    nxt=. (*k)*nxt+1
    cnt=. (1+k{cnt) k} cnt=. cnt {.~ (2+k)>.#cnt
    seq=. seq, k
  end.
}}
