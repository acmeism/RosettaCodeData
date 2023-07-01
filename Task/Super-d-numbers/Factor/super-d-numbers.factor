USING: arrays formatting io kernel lists lists.lazy math
math.functions math.ranges math.text.utils prettyprint sequences
;
IN: rosetta-code.super-d

: super-d? ( seq n d -- ? ) tuck ^ * 1 digit-groups subseq? ;

: super-d ( d -- list )
    [ dup <array> ] [ drop 1 lfrom ] [ ] tri [ super-d? ] curry
    with lfilter ;

: super-d-demo ( -- )
    10 2 6 [a,b] [
        dup "First 10 super-%d numbers:\n" printf
        super-d ltake list>array [ pprint bl ] each nl nl
    ] with each ;

MAIN: super-d-demo
