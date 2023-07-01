include random.fs

variable stay-wins
variable switch-wins

: trial ( -- )
  3 random 3 random ( prize choice )
  = if 1 stay-wins +!
  else 1 switch-wins +!
  then ;
: trials ( n -- )
  0 stay-wins ! 0 switch-wins !
  dup 0 do trial loop
  cr   stay-wins @ . [char] / emit dup . ." staying wins"
  cr switch-wins @ . [char] / emit     . ." switching wins" ;

1000 trials
