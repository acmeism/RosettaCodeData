USING: kernel math math.ranges math.text.utils memoize
prettyprint sequences tools.time ;
IN: rosetta-code.iterated-digits-squaring

: sum-digit-sq ( n -- m ) 1 digit-groups [ sq ] map-sum ;

MEMO: 1or89 ( n -- m )
    [ dup [ 1 = ] [ 89 = ] bi or ] [ sum-digit-sq ] until ;

[
    0 1
    [
        dup sum-digit-sq 1or89 89 = [ [ 1 + ] dip ] when
        1 + dup 100,000,000 <
    ] loop
    drop .
] time
