warnings off

4  \ iterations
: **        1 swap  0 ?DO over * LOOP  nip ;
3 swap **  constant width  \ Make smallest step 1

create string  here width char # fill  width allot
: print     string width type cr ;

\  Overwrite string with new holes of size 'length'.
\  Pointer into string at TOS.
create length  width ,
: reduce    length dup @ 3 / swap ! ;
: done?     dup string - width >= ;
: hole?     dup c@ bl = ;
: skip      length @ + ;
: whipe     dup length @ bl fill  skip ;
: step      hole? IF skip skip skip ELSE skip whipe skip THEN ;
: split     reduce string BEGIN step done? UNTIL drop ;

\  Main
: done?     length @ 1 <= ;
: step      split print ;
: go        print BEGIN step done? UNTIL ;

go bye
