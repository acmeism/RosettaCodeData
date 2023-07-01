loop =: verb define@:x:
 i =. y
 while. y >: # i do.
  i =. (, (isPrime # _1 2&p.)@:{:) i
  i =. _1 (>:@:{)`[`]} i
 end.
 }: i
)
