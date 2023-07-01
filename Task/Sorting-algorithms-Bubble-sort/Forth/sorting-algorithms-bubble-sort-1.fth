defer bubble-test
' > is bubble-test

: bubble { addr cnt -- }
  cnt 1 do
    addr cnt i - cells bounds do
      i 2@ bubble-test if i 2@ swap i 2! then
    cell +loop
  loop ;
