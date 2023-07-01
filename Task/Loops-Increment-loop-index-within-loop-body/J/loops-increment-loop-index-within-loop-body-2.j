isPrime =: 1&p:
assert 1 1 0 -: isPrime 2 3 4   NB. test and example

loop =: verb define
 i =. x: y
 n =. i. 0
 while. y > # n do.
  if. isPrime i do.
   n =. n , i
   i =. _1 2 p. i
  end.
  i =. i + 1
 end.
 n
)
