: place-n ( src len dest n -- )
  swap >r 0 r@ c!
  begin dup while -rot 2dup r@ +place rot 1- repeat
  r> 2drop 2drop ;

s" ha" pad 5 place-n
pad count type    \ hahahahaha
