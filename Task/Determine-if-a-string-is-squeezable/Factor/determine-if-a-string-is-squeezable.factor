USING: formatting fry io kernel math sbufs sequences strings ;
IN: rosetta-code.squeeze

: (squeeze) ( str c -- new-str )
    [ unclip-slice 1string >sbuf ] dip
    '[ over last over [ _ = ] both? [ drop ] [ suffix! ] if ]
    reduce >string ;

: squeeze ( str c -- new-str )
    over empty? [ 2drop "" ] [ (squeeze) ] if ;

: .str ( str -- ) dup length "«««%s»»» (length %d)\n" printf ;

: show-squeeze ( str c -- )
    dup "Specified character: '%c'\n" printf
    [ "Before squeeze: " write drop .str ]
    [ "After  squeeze: " write squeeze .str ] 2bi nl ;

: squeeze-demo ( -- )
    {
        ""
        "\"If I were two-faced, would I be wearing this one?\" --- Abraham Lincoln "
        "..1111111111111111111111111111111111111111111111111111111111111117777888"
        "I never give 'em hell, I just tell the truth, and they think it's hell. "
    } "\0-7." [ show-squeeze ] 2each

    "                                                   ---  Harry S Truman  "
    [ CHAR: space ] [ CHAR: - ] [ CHAR: r ] tri
    [ show-squeeze ] 2tri@ ;

MAIN: squeeze-demo
