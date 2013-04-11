: place-n { src len dest n -- }
  0 dest c!
  n 0 ?do src len dest +place loop ;

s" ha" pad 5 place-n
pad count type    \ hahahahaha
