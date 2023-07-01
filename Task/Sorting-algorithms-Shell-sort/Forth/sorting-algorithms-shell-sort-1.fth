defer less?   ' < is less?

: shell { array len -- }
  1 begin dup len u<= while 2* 1+ repeat { gap }
  begin gap 2 = if 1 else gap 5 11 */ then dup to gap while
    len gap do
      array i cells +
      dup @ swap         ( temp last )
      begin gap cells -
            array over u<=
      while 2dup @ less?
      while dup gap cells + over @ swap !
      repeat then
      gap cells + !
    loop
  repeat ;

create array 8 , 1 , 4 , 2 , 10 , 3 , 7 , 9 , 6 , 5 ,

array 10 shell
array 10 cells dump
