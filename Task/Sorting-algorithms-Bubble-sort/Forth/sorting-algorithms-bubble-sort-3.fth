: bubble ( addr len -- )
  begin
    1- 2dup  true -rot  ( sorted addr len-1 )
    cells bounds ?do
      i 2@ bubble-test if
        i 2@ swap i 2!
        drop false   ( mark unsorted )
      then
    cell +loop  ( sorted )
  until 2drop ;
