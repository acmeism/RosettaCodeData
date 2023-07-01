loop =: verb define@:x:
 i =. y
 while. y >: # i do.
  if. isPrime {: i do.
   i =. (, _1 2 p. {:) i
  end.
  i =. _1 (>:@:{)`[`]} i
 end.
 }: i
)
