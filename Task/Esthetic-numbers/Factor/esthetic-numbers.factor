USING: combinators deques dlists formatting grouping io kernel
locals make math math.order math.parser math.ranges
math.text.english prettyprint sequences sorting strings ;

:: bfs ( from to num base -- )
    DL{ } clone :> q
    base 1 - :> ld
    num q push-front
    [ q deque-empty? ]
    [
        q pop-back :> step-num
        step-num from to between? [ step-num , ] when
        step-num zero? step-num to > or
        [
            step-num base mod :> last-digit
            step-num base * last-digit 1 - + :> a
            step-num base * last-digit 1 + + :> b

            last-digit
            {
                { 0 [ b q push-front ] }
                { ld [ a q push-front ] }
                [ drop a q push-front b q push-front ]
            } case

        ] unless

    ] until ;

:: esthetics ( from to base -- seq )
    [ base <iota> [| num | from to num base bfs ] each ]
    { } make natural-sort ;

: .seq ( seq width -- )
    group [ [ dup string? [ write ] [ pprint ] if bl ] each nl ]
    each nl ;

:: show ( base -- )
    base [ 4 * ] [ 6 * ] bi :> ( from to )
    from to [ dup ordinal-suffix ] bi@ base
    "%d%s through %d%s esthetic numbers in base %d\n" printf
    from to 1 + 0 5000   ! enough for base 16
    base esthetics subseq [ base >base ] map 17 .seq ;

2 16 [a,b] [ show ] each

"Base 10 numbers between 1,000 and 9,999:" print
1,000 9,999 10 esthetics 16 .seq

"Base 10 numbers between 100,000,000 and 130,000,000:" print
100,000,000 130,000,000 10 esthetics 9 .seq

"Count of base 10 esthetic numbers between zero and one quadrillion:"
print 0 1e15 10 esthetics length .
