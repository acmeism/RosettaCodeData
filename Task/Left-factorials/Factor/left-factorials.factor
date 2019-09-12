USING: formatting fry io kernel math math.factorials
math.functions math.parser math.ranges sequences ;
IN: rosetta-code.left-factorials

: left-factorial ( n -- m ) <iota> [ n! ] map-sum ;

: print-left-factorials ( seq quot -- )
    '[
        dup left-factorial @
        [ number>string "!" prepend ] dip
        "%6s   %-6d\n" printf
    ] each nl ; inline

: digit-count ( n -- count ) log10 >integer 1 + ;

: part1 ( -- ) 11 <iota> [ ] print-left-factorials ;

: part2 ( -- ) 20 110 10 <range> [ ] print-left-factorials ;

: part3 ( -- )
    "Number of digits for" print
    1,000 10,000 1,000 <range>
    [ digit-count ] print-left-factorials ;

: main ( -- ) part1 part2 part3 ;

MAIN: main
