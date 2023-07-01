comb2=: dyad define
  d =. 1 + y - x
  k =. >: |. i. d
  z =. < \. |. i. d
  for. i.x-1 do.
     z=. , each /\. k ,. each z
     k =. 1 + k
  end.
  ;{.z
)
