USING: io kernel lists lists.lazy math math.functions
math.primes math.ranges prettyprint sequences
tools.memory.private ;

! Create a palindrome from its base natural number.
: create-palindrome ( n odd? -- m )
    dupd [ 10 /i ] when swap [ over 0 > ]
    [ 10 * [ 10 /mod ] [ + ] bi* ] while nip ;

! Create an ordered infinite lazy list of palindromic numbers.
: lpalindromes ( -- l )
    0 lfrom [
        10 swap ^ dup 10 * [a,b)
        [ [ t create-palindrome ] map ]
        [ [ f create-palindrome ] map ] bi
        [ sequence>list ] bi@ lappend
    ] lmap-lazy lconcat ;

: lpalindrome-primes ( -- list )
    lpalindromes [ prime? ] lfilter ;

"10,000th palindromic prime:" print
9999 lpalindrome-primes lnth commas print nl

"Palindromic primes less than 1,000:" print
lpalindrome-primes [ 1000 < ] lwhile [ . ] leach
