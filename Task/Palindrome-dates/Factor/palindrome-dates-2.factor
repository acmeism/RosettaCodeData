USING: calendar calendar.format continuations io kernel lists
lists.lazy math math.functions math.parser math.ranges sequences ;

: create-palindrome ( n odd? -- m )
    dupd [ 10 /i ] when swap [ over 0 > ]
    [ 10 * [ 10 /mod ] [ + ] bi* ] while nip ;

: palindromes ( -- list )
    3 lfrom [
        10 swap ^ dup 10 * [a,b)
        [ [ t create-palindrome ] map ]
        [ [ f create-palindrome ] map ] bi
        [ sequence>list ] bi@ lappend
    ] lmap-lazy lconcat [ 20200202 >= ] lfilter ;

: palindrome-dates ( -- list )
    palindromes [
        number>string 4 cut* 2 cut [ string>number ] tri@
        [ <date> ] [ 4drop f ] recover
    ] lmap-lazy [ f = not ] lfilter ;

"10,000th palindrome date after 2020-02-02: " write
10,000 palindrome-dates lnth timestamp>ymd print
