USING: formatting kernel math math.factorials math.functions
math.ranges sequences ;
IN: rosetta-code.hickerson

: ln2 ( -- x )
    99 [1,b] [ [ 2 swap ^ ] [ * ] bi recip ] map-sum ;

: hickerson ( n -- x ) [ n! ] [ 1 + ln2 swap ^ 2 * ] bi / ;

: almost-int? ( x -- ? ) 10 * truncate 10 mod { 0 9 } member? ;

: hickerson-demo ( -- )
    18 [1,b] [
        dup hickerson dup almost-int?
        "h(%02d) = %23.3f   almost integer? %u\n" printf
    ] each ;

MAIN: hickerson-demo
