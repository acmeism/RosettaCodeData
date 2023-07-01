\ Build up a "language" for date formatting

\ utility words
: UNDER+  ( a b c -- a+c b )  ROT + SWAP ;
: 3DUP    ( a b c -- a b c a b c ) 2 PICK 2 PICK 2 PICK ;
: WRITE$  ( caddr -- ) COUNT TYPE ;  \ print a counted string
: ','     ( -- )  ." , "  ;
: '-'     ( -- )  ." -"   ;

\ day of week calculation
\ "This is an algorithm I've carried with me for 35 years,
\  originally in Assembler and Fortran II."
\  It counts the number of days from March 1, 1900."
\                                    Wil Baden R.I.P.
\ *****************************************************
\ **WARNING** only good until 2078 on 16 bit machine **
\ *****************************************************
DECIMAL
: CDAY    ( dd mm yyyy -- century_day )
      -3 UNDER+  OVER  0<
      IF   12 UNDER+  1-   THEN
      1900 -  1461 4 */   SWAP 306 *  5 +  10 /  + +  ;

: DOW   ( cday -- day_of_week ) 2 + 7 MOD 1+ ; ( 7 is Sunday)

\ formatted number printers
: ##.   ( n -- )  0 <#  # #      #> TYPE ;
: ####. ( n -- )  0 <#  # # # #  #> TYPE ;

\ make some string list words
: LIST[   ( -- ) !CSP  0 C,  ;         \ list starts with 0 bytes, record stack pos.
: ]LIST   ( -- ) 0 C, ALIGN ?CSP ;     \ '0' ends list, check stack

: NEXT$   ( $[1] -- $[2] )    COUNT + ;               \ get next string
: NTH$    ( n list -- $addr ) SWAP 0 DO NEXT$ LOOP ;  \ get nth string

: "       ( -- ) [CHAR] " WORD  C@ CHAR+ ALLOT ;      \ compile text upto "

\ make the lists
CREATE MONTHS
  LIST[ " January" " February"  " March"   " April" " May" " June" " July"
        " August"  " September" " October" " November" " December" ]LIST

CREATE DAYS
  LIST[ " Monday" " Tuesday" " Wednesday"  " Thursday"
        " Friday" " Saturday" " Sunday" ]LIST

\ expose lists as indexable arrays that print the string
: ]MONTH$.  ( n -- )  MONTHS NTH$ WRITE$ ;
: ]DAY$.    ( n -- )  DAYS NTH$ WRITE$ ;


\ ===========================================
\ Rosetta Task Code Begins

\ Rosetta Date Format 1
: Y-M-D.     ( d m y -- )  ####. '-' ##. '-' ##. ;

\ Rosetta Date Format 2
: LONG.DATE ( d m y -- )
    3DUP CDAY DOW ]DAY$. ',' -ROT ]MONTH$. SPACE ##.  ','  ####.  ;
