\ works with ficl, pfe, gforth, bigforth, and vfx.
\ swiftforth may crash, iforth does not function.

: create_goto create 4 allot does> r> drop @ >r ;
: mark_goto here ' >body ! ; immediate

create_goto goto1
create_goto goto2
create_goto goto3
create_goto goto4
create_goto goto5
create_goto goto6
create_goto goto7
create_goto goto8
create_goto goto9
create_goto stop_here

:noname
mark_goto goto1   s" iteration " type dup . s" --> " type
                  s" goto1 " type   goto3
mark_goto goto2   s" goto2 " type   goto4
mark_goto goto3   s" goto3 " type   goto5
mark_goto goto4   s" goto4 " type   goto6
mark_goto goto5   s" goto5 " type   goto7
mark_goto goto6   s" goto6 " type   goto8
mark_goto goto7   s" goto7 " type   goto9
mark_goto goto8   s" goto8 " type   stop_here
mark_goto goto9   s" goto9 " type   goto2 ; drop

:noname  mark_goto stop_here
  cr 2dup = if 2drop exit then 1+ goto1
\ cr 2dup = if 2drop bye  then 1+ goto1  \ for swiftforth
; drop

: go goto1 ;
5 1 go

bye
