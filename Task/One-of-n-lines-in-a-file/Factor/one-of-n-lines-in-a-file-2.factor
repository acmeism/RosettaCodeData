! rosettacode/one-of-n/one-of-n.factor
USING: accessors io kernel math rosettacode.random-line ;
IN: rosettacode.one-of-n

<PRIVATE
TUPLE: mock-stream count last ;
: <mock-stream> ( n -- stream )
    mock-stream new 0 >>count swap >>last ;
M: mock-stream stream-readln ! stream -- line
    dup [ count>> ] [ last>> ] bi <
    [ [ 1 + ] change-count count>> ]
    [ drop f ] if ;
PRIVATE>

: one-of-n ( n -- line )
    <mock-stream> [ random-line ] with-input-stream* ;

USING: assocs formatting locals sequences sorting ;
<PRIVATE
: f>0 ( object/f -- object/0 )
    dup [ drop 0 ] unless ;
:: test-one-of-n ( -- )
    H{ } clone :> chosen
    1000000 [
        10 one-of-n chosen [ f>0 1 + ] change-at
    ] times
    chosen keys natural-sort [
        dup chosen at "%d chosen %d times\n" printf
    ] each ;
PRIVATE>
MAIN: test-one-of-n
