: weekday ( d m y -- u )
   over 3 < if swap 12 + swap 1- then
   dup 4 / over 100 / - over 400 / + + swap 1+ 13 * 5 / + + 2 - 7 mod ;

: mdays ( m y -- msize mday )
   over 12 = if 31 1 2swap weekday negate exit then
   2>r 1 2r@ weekday 1 2r> swap 1+ swap weekday over -
   7 + 7 mod 28 + swap negate ;

: .week ( msize mday -- msize mday' )
   7 0 do dup 0< if 1+ 3 spaces else
   2dup > if 1+ dup 2 .r space else 3 spaces then then loop ;

: .3months ( y m -- )
   3 0 do ." Mo Tu We Th Fr Sa Su   " loop cr
   3 over + swap do i over mdays rot loop drop
   6 0 do 2rot .week 2 spaces 2rot .week 2 spaces 2rot .week cr loop
   2drop 2drop 2drop ;

: cal ( y -- )
   30 spaces ." [Snoopy]" cr
   32 spaces dup . cr
   ."       January                February                March" cr
   dup 1 .3months
   ."        April                   May                    June" cr
   dup 4 .3months
   ."         July                  August                September" cr
   dup 7 .3months
   ."         October               November               December" cr
   10 .3months ;

1969 cal
