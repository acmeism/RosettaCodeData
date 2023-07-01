USING: arrays assocs combinators.random io kernel macros math
math.statistics prettyprint quotations sequences sorting formatting ;
IN: rosettacode.proba

CONSTANT: data
{
    { "aleph"   1/5.0 }
    { "beth"    1/6.0 }
    { "gimel"   1/7.0 }
    { "daleth"  1/8.0 }
    { "he"      1/9.0 }
    { "waw"     1/10.0 }
    { "zayin"   1/11.0 }
    { "heth"    f }
}

MACRO: case-probas ( data -- case-probas )
    [ first2 [ swap 1quotation 2array ] [ 1quotation ] if* ] map 1quotation ;

: expected ( name data -- float )
    2dup at [ 2nip ] [ nip values sift sum 1 swap - ] if* ;
: generate ( # case-probas -- seq )
    H{ } clone
    [ [ [ casep ] [ inc-at ] bi* ] 2curry times ] keep ; inline
: normalize ( seq # -- seq )
    [ clone ] dip [ /f ] curry assoc-map ;
: summarize1 ( name value data -- )
    [ over ] dip expected
    "%6s: %10f %10f\n" printf ;
: summarize ( generated data -- )
    "Key" "Value" "expected" "%6s  %10s %10s\n" printf
    [ summarize1 ] curry assoc-each ;
: generate-normalized ( # proba -- seq )
    [ generate ] [ drop normalize ] 2bi ; inline
: example ( # data -- )
    [ case-probas generate-normalized ]
    [ summarize ] bi ; inline
