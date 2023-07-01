save_if_prime =: , (isPrime # _1 2&p.)@:{:
increment_tail =: _1&(>:@:{`[`]})

loop =: verb define@:x:
 i =. y
 while. y >: # i do.
  i =. save_if_prime i
  i =. increment_tail i
 end.
 }: i
)
