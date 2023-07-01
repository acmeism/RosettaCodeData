: bubble ( addr cnt -- )
  dup 1 do
    2dup i - cells bounds do
      i 2@ bubble-test if i 2@ swap i 2! then
    cell +loop
  loop ;
