: ?adjust 1+ over and if 2* 15 and >r 2 - r> then ;
: accumulate >r dup >r + r> r> ;
: classify dup 0> if 1- then 5 / ;
: calculate do i ?adjust accumulate loop drop drop 100 min ;
: normalize classify >r 0 10 2 r> 1+ 0 calculate ;
: print s>d <# # # [char] . hold #s #> type ;

: test cr 101 0 ?do i print i 2 spaces normalize print cr 5 +loop ;

test
