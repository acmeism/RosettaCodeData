USING: io kernel math math.parser sequences ;

: thue-morse ( seq n -- seq' )
    [ [ ] [ [ 1 bitxor ] map ] bi append ] times ;

: print-tm ( seq -- ) [ number>string ] map "" join print ;

7 <iota> [ { 0 } swap thue-morse print-tm ] each
