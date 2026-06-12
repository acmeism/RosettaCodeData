USING: formatting io kernel math math.factorials math.functions
math.parser math.ranges prettyprint sequences sequences.extras ;
IN: rosetta-code.special-factorials

: sf ( n -- m ) [1..b] [ n! ] map-product ;
: (H) ( n -- m ) [1..b] [ dup ^ ] map-product ;
: H ( n -- m ) [ 1 ] [ (H) ] if-zero ;
:: af ( n -- m ) n [1..b] [| i | -1 n i - ^ i n! * ] map-sum ;
: $ ( n -- m ) [1..b] [ ] [ swap ^ ] map-reduce ;

: (rf) ( n -- m )
    [ 1 1 ] dip [ dup reach > ]
    [ [ 1 + [ * ] keep ] dip ] while swapd = swap and ;

: rf ( n -- m ) dup 1 = [ drop 0 ] [ (rf) ] if ;

: .show ( n quot -- )
    [ pprint bl ] compose each-integer nl ; inline

"First 10 superfactorials:" print
10 [ sf ] .show nl

"First 10 hyperfactorials:" print
10 [ H ] .show nl

"First 10 alternating factorials:" print
10 [ af ] .show nl

"First 5 exponential factorials:" print
5 [ $ ] .show nl

"Number of digits in 5$:" print
5 $ log10 >integer 1 + . nl

{ 1 2 6 24 120 720 5040 40320 362880 3628800 119 }
[ dup rf "rf(%d) = %u\n" printf ] each nl
