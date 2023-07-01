warnings off

1.000.000.000.000.000 drop constant 1.0fx  \ fractional part is 15 decimal digits.

: .h  ( n -- )
    s>d <#  14 for # next  [char] . hold #s #> type space ;

1.0fx 1 2constant first-harmonic

: round  5 + 10 / ;

: next-harmonic ( h n -- h' n' )
    1+ tuck [ 1.0fx 10 * ] literal swap / round + swap ;

: task1
    first-harmonic  19 for  over cr .h next-harmonic  next 2drop ;

: task2
    first-harmonic
    11 1 do
        begin over i 1.0fx * <= while
            next-harmonic
        repeat
        dup .
    loop 2drop ;

." The first 10 harmonic numbers: " task1 cr cr
." The nth index of the first harmonic number that exceeds the nth integer: " cr task2 cr
bye
