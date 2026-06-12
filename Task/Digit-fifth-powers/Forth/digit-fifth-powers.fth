: p5 ( u -- u )
  dup dup * dup * * ;

: sum5 ( u -- u )
  dup 10 < if p5 exit then
  10 /mod swap p5 swap recurse + ;

: main
  0 9 p5 6 * 2 do
    i sum5 i = if
      i +
    then
  loop
  . cr ;

main
bye
