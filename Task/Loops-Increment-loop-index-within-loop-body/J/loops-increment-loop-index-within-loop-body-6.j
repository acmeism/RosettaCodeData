loop =: verb define@:x:
 i =. y
 while. y >: # i do.
  i =. increment_tail@:save_if_prime i
 end.
 }: i
)
