20 constant date-size
create max-dates date-size 100 * allot
variable max-out
variable counter

stdin value input

: process ( addr len -- )
  8 /string
  over 3 s" OUT" compare 0= if
    1 counter +!
    counter @ max-out @ > if
      counter @ max-out !
      drop 5 + date-size max-dates  place
    else counter @ max-out @ = if
      drop 5 + date-size max-dates +place
    else 2drop then then
  else drop 2 s" IN" compare 0= if
    -1 counter +!
  then then ;

: main
  0 max-out !
  0 counter !
  s" mlijobs.txt" r/o open-file throw to input
  begin  pad 80 input read-line throw
  while  pad swap process
  repeat drop
  input close-file throw
  max-out @ . ." max licenses in use @"
  max-dates count type cr ;

main bye
