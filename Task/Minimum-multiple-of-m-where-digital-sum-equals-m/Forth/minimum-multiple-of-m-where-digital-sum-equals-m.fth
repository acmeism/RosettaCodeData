: digit-sum ( u -- u )
  dup 10 < if exit then
  10 /mod recurse + ;

: main
  1+ 1 do
    0
    begin
      1+ dup i * digit-sum i =
    until
    8 .r i 10 mod 0= if cr else space then
  loop ;

70 main
bye
