moo =: verb define
  s =. m =. 0 $~ ,~ n=._1+#y
  for_lmo. 1+i.<:n do.
    for_i. i. n-lmo do.
      j =. i + lmo
      m =. _ (<i;j)} m
      for_k. i+i.j-i do.
        cost =. ((<i;k){m) + ((<(k+1);j){m) + */ y {~ i,(k+1),(j+1)
        if. cost < ((<i;j){m) do.
          m =. cost (<i;j)} m
          s =. k (<i;j)} s
        end.
      end.
    end.
  end.

  m;s
)

poco =: dyad define
  'i j' =. y
   if. i=j do.
     a. {~ 65 + i      NB. 65 = a.i.'A'
   else.
     k =. x {~ <y      NB. y = i,j
     '(' , (x poco i,k) , (x poco j ,~ 1+k) , ')'
   end.
)

optMM =: verb define
  'M S' =. moo y
  smoutput 'Cost: ' , ": x: M {~ <0;_1
  smoutput 'Order: ', S poco 0 , <:#M
)
